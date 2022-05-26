
import 'dart:convert';
import 'dart:math';

import 'package:bip39/bip39.dart' as bip39;
import 'package:bip32/bip32.dart' as bip32;
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/data/models/network_gas_fee.dart';
import 'package:sing_app/data/models/transaction_hash.dart';
import 'package:sing_app/data/response/ss_response.dart';
import 'package:sing_app/data/response/wallet_api_response.dart';
import 'package:sing_app/utils/abi/erc721.g.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/logging_client.dart';
import 'package:web3dart/contracts/erc20.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

abstract class TokenUtil {
  static String getPrivateKey(String mnemonic) {
    final seed = bip39.mnemonicToSeed(mnemonic);
    final root = bip32.BIP32.fromSeed(seed);
    final child1 = root.derivePath("m/44'/60'/0'/0/0");
    return bytesToHex(child1.privateKey!);
  }

  static Future<EthereumAddress> getPublicAddress(String privateKey) async {
    final private = EthPrivateKey.fromHex(privateKey);
    final address = await private.extractAddress();
    return address;
  }

  static Future<EtherAmount?> getBalance({required String walletAddress, required String rpcUrl}) async {
    LoggerUtil.debug('get balance for $walletAddress at $rpcUrl');
    try{
      final client = Web3Client(rpcUrl, LoggingClient(Client()));
      EtherAmount balance = await client.getBalance(EthereumAddress.fromHex(walletAddress));
      return balance;
    } catch(exc, trace){
      LoggerUtil.trace('error getting balance', trace);
    }

    return null;
  }

  static Future<EtherAmount?> getTokenBalance({required String walletAddress, required String contractAddress, required String rpcUrl}) async {
    if(walletAddress.isEmpty || contractAddress.isEmpty){
      return null;
    }
    final client = Web3Client(rpcUrl,  LoggingClient(Client()));
    try{
      final ethContractAddress = EthereumAddress.fromHex(contractAddress);
      final ethWalletAddress = EthereumAddress.fromHex(walletAddress);
      final token = Erc20(address: ethContractAddress, client: client);
      final bIntBalance = await token.balanceOf(ethWalletAddress);
      final balance = EtherAmount.fromUnitAndValue(EtherUnit.wei, bIntBalance);
      return balance;
    }catch(exc, trace){
      LoggerUtil.trace('error getting token balance', trace);
    }

    return null;
  }

  static Future<NetworkGasFee?> estimateGas({required String toAddress, required double amount, required String gasSymbol, required String rpcUrl}) async {
    final ether = EtherAmount.fromUnitAndValue(EtherUnit.wei, BigInt.from(amount * pow(10, 18)));
    LoggerUtil.debug('estimateGas: $toAddress, $amount => ${amount * pow(10, 18)} => ${ether.getValueInUnit(EtherUnit.wei).toDouble()}');
    final client = Web3Client(rpcUrl,  LoggingClient(Client()));

    try{
      final gasPrice = await client.getGasPrice();
      LoggerUtil.debug('gasPrice: $gasPrice');

      final transaction = Transaction(
        to: EthereumAddress.fromHex(toAddress),
        value: EtherAmount.fromUnitAndValue(EtherUnit.wei, BigInt.from(amount * pow(10, 18))),
      );
      final response = await client.estimateGas(to: transaction.to, value: transaction.value, data: transaction.data);
      final networkGasFee = NetworkGasFee(
        gasWei: response.toDouble(),
        gasPriceWei: gasPrice.getInWei.toDouble(),
        gasFeeWei: response.toDouble() * gasPrice.getInWei.toDouble(),
        gasFeeNative: 0,
        nativeSymbol: gasSymbol,
        gasFeeUsd: -1,
      );
      final dValue = networkGasFee.gasWei * networkGasFee.gasPriceWei / pow(10, 18);
      networkGasFee.gasFeeNative = dValue;
      LoggerUtil.debug('networkGasFee response: ${networkGasFee.toJson()}');
      return networkGasFee;
    }catch(exc, trace){
      LoggerUtil.trace('error estimateGas', trace);
    }
    return null;
  }

  static Future<DefaultSsResponse<TransactionHash>> sendToken({
    required String privateKey,
    required String toAddress,
    required double amount,
    required String rpcUrl,
    required int chainId,
    String tokenContract = '',
    }) async {
    final client = Web3Client(rpcUrl, LoggingClient(Client()));
    final credentials = EthPrivateKey.fromHex(privateKey);

    try{
      final eaTo = EthereumAddress.fromHex(toAddress);
      final bAmount = BigInt.from(amount * pow(10, 18));
      String response = '';
      if(tokenContract.isNotEmpty){
        LoggerUtil.debug('transfer erc20 token $tokenContract');
        final token = Erc20(address: EthereumAddress.fromHex(tokenContract), client: client, chainId: chainId);
        response = await token.transfer(eaTo, bAmount, credentials: credentials);
      } else {
        final gasPrice = await client.getGasPrice();

        final transaction = Transaction(
          to: eaTo,
          gasPrice: gasPrice,
          value: EtherAmount.fromUnitAndValue(EtherUnit.wei, bAmount),
        );
        response = await client.sendTransaction(credentials, transaction, chainId: chainId);
      }

      LoggerUtil.debug('transfer response: $response');
      if(response.contains('{')){
        final json = jsonDecode(response);
        if(json['error'] != null){
          return DefaultSsResponse.withError(SsError.fromJson(json['error']));
        }
      } else {
        final result = DefaultSsResponse<TransactionHash>()
          ..data = TransactionHash(transactionHash: response)
          ..success = true;
        return result;
      }
    }catch(exc, trace){
      LoggerUtil.trace('error transfer', trace);
    }
    return DefaultSsResponse.withError(SsError(
      code: -1,
      message: l('Error sending token'),
    ));
  }

  static Future<DefaultSsResponse<TransactionHash>> sendNft({required String privateKey, required String toAddress, required String tokenContract, required int tokenId, required String rpcUrl, required int chainId}) async {
    final client = Web3Client(rpcUrl, LoggingClient(Client()));
    final credentials = EthPrivateKey.fromHex(privateKey);

    try{
      final ownAddress = await credentials.extractAddress();
      final token = Erc721(address: EthereumAddress.fromHex(tokenContract), client: client, chainId: chainId);
      LoggerUtil.debug('send nft from $ownAddress to: $toAddress, tokenContract: $tokenContract');
      final response = await token.transferFrom(ownAddress, EthereumAddress.fromHex(toAddress), BigInt.from(tokenId), credentials: credentials);

      LoggerUtil.debug('transfer response: $response');
      if(response.contains('{')){
        final json = jsonDecode(response);
        if(json['error'] != null){
          return DefaultSsResponse.withError(SsError.fromJson(json['error']));
        }
      } else {
        final result = DefaultSsResponse<TransactionHash>()
          ..data = TransactionHash(transactionHash: response)
          ..success = true;
        return result;
      }
    }catch(exc, trace){
      LoggerUtil.trace('error transfer', trace);
    }
    return DefaultSsResponse.withError(SsError(
      code: -1,
      message: l('Error sending token'),
    ));
  }


  static List<String> mnemonicWords(String mnemonic) {
    return mnemonic
        .split(' ')
        .where((item) => item.trim().isNotEmpty)
        .map((item) => item.trim())
        .toList();
  }

  static bool validateMnemonic(String mnemonic) {
    return mnemonicWords(mnemonic).length == 12;
  }
}