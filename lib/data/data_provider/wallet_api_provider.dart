
import 'dart:convert';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/data/data_provider/api_manager.dart';
import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/data/models/contract_info.dart';
import 'package:sing_app/data/models/network_gas_fee.dart';
import 'package:sing_app/data/models/transaction_hash.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/data/response/ss_response.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class WalletApiProvider {
  late BaseAPI _baseAPI;

  WalletApiProvider(BaseAPI baseAPI) {
    _baseAPI = baseAPI;
  }

  Future<DefaultSsResponse< List<Wallet> >> getWallets() async {
    try {
      final Map responseJson = await _baseAPI.request(
        manager: ApiManager(ApiType.wallets),

      );
      final response = DefaultSsResponse.fromMap(responseJson);
      if (response.success && response.data != null) {
        final List<Wallet> items = [];
        for (final itemJson in response.data ?? []) {
          final item = Wallet.fromJson(itemJson);
          items.add(item);
        }
        return DefaultSsResponse<List<Wallet>>(
          data: items,
        );
      } else {
        return DefaultSsResponse<List<Wallet>>(
          error: response.error,
          success: false
        );
      }
    } catch (exception) {
      return DefaultSsResponse<List<Wallet>>.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse< List<Balance> >> getWalletTokenBalances(String walletId) async {
    try {
      final Map responseJson = await _baseAPI.request(
        manager: ApiManager(ApiType.tokenBalances),
        optionalPath: '/$walletId/balance/tokens'
      );
      final response = DefaultSsResponse.fromMap(responseJson);
      if (response.success && response.data != null) {
        final List<Balance> items = [];
        for (final itemJson in response.data ?? []) {
          final item = Balance.fromJson(itemJson);
          items.add(item);
        }
        return DefaultSsResponse<List<Balance>>(
            data: items,
            error: null,
            success: true
        );
      } else {
        return DefaultSsResponse<List<Balance>>(
            data: null,
            error: response.error,
            success: false
        );
      }
    } catch (exception) {
      return DefaultSsResponse<List<Balance>>.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  // Future<WalletPaginationResponse< int >> getWalletNfts(String walletId) async {
  //   try {
  //     final Map responseJson = await _baseAPI.request(
  //         manager: ApiManager(ApiType.tokenBalances),
  //         optionalPath: '/$walletId/nonfungibles'
  //     );
  //     final response = WalletPaginationResponse.fromJson(responseJson);
  //     if (response.success) {
  //       final List<int> items = [];
  //       for (final itemJson in response.data) {
  //         final item = itemJson as int;
  //         items.add(item);
  //       }
  //       return WalletPaginationResponse<int>(
  //           data: items,
  //           errors: null,
  //           success: true,
  //           page: response.page,
  //           total: response.total
  //       );
  //     } else {
  //       return WalletPaginationResponse.withErrors(
  //           response.errors!,
  //       );
  //     }
  //   } catch (exception) {
  //     return WalletPaginationResponse.withError(
  //       WalletError(message: exception.toString()),
  //     );
  //   }
  // }

  Future<DefaultSsResponse> getTokenPrice(String symbol, {String to = 'USDT'}) async {
    try {
      final Map responseJson = await _baseAPI.request(
          manager: ApiManager(ApiType.tokenPrice),
          queryParams: {
            'symbol': '${symbol.toUpperCase()}${to.toUpperCase()}'
          },
          isUseAccessToken: false,
      );
      final response = DefaultSsResponse.fromMap(responseJson);
      return response;
    } catch (exception) {
      return DefaultSsResponse.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse< NetworkGasFee >> calculateNetworkGasFee({required double price, required String priceSymbol, required String walletId}) async {
    try {
      final Map responseJson = await _baseAPI.request(
          manager: ApiManager(ApiType.networkGasFee),
          bodyParams: {
            'price': price,
            'price_symbol': priceSymbol,
            'wallet_id': walletId
          }
      );
      final dataResponse = DefaultSsResponse.fromMap(responseJson);
      if(dataResponse.success){
        final data = NetworkGasFee.fromJson(dataResponse.data);
        return DefaultSsResponse<NetworkGasFee>(
            data: data,
            error: null,
            success: true
        );
      } else {
        return DefaultSsResponse<NetworkGasFee>(
            error: dataResponse.error,
            success: false
        );
      }

    } catch (exception) {
      LoggerUtil.error('error: $exception');
      return DefaultSsResponse<NetworkGasFee>.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse<TransactionHash>> sendToken({required String tokenContract, required double amount, required String address, required String walletId}) async {
    try {
      //encrypt param
      final String jsonData = jsonEncode({
        "token_contract": tokenContract,
        "token_amount": amount,
        "receiver_address": address,
      });
      final b64key = encrypt.Key.fromBase64(encryptionKey);
      final fernet = encrypt.Fernet(b64key);
      final encryptor = encrypt.Encrypter(fernet);
      final encrypted = encryptor.encrypt(jsonData);

      final Map responseJson = await _baseAPI.request(
        manager: ApiManager(ApiType.sendToken),
          optionalPath: '/$walletId/token/send',
          bodyParams: {
            'encrypted': encrypted.base64,
          }
      );

      final response = DefaultSsResponse.fromMap(responseJson);
      if (response.success && response.data != null) {
        final data = TransactionHash.fromJson(response.data);
        return DefaultSsResponse<TransactionHash>(
            data: data,
            error: null,
            success: true
        );
      } else {
        return DefaultSsResponse<TransactionHash>(
            data: null,
            error: response.error,
            success: false
        );
      }

    } catch (exception) {
      return DefaultSsResponse.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse<Balance>> addCustomToken({required String walletId, required Map<String, dynamic> params}) async {
    try {
      //encrypt param
      final String jsonData = jsonEncode({
        "token_contract": params['token_contract'],
        "decimals": params['decimals'] as int,
      });

      final b64key = encrypt.Key.fromBase64(encryptionKey);
      final fernet = encrypt.Fernet(b64key);
      final encryptor = encrypt.Encrypter(fernet);
      final encrypted = encryptor.encrypt(jsonData);

      final Map responseJson = await _baseAPI.request(
        manager: ApiManager(ApiType.addCustomToken, additionalPath: walletId),
        bodyParams: {
          'encrypted': encrypted.base64,
        },
        isUseAccessToken: true,
      );
      final response = DefaultSsResponse.fromMap(responseJson);
      if (response.success && response.data != null) {
        final balance = Balance.fromJson(response.data);
        return DefaultSsResponse<Balance>(
            data: balance,
            error: null,
            success: true
        );
      } else {
        return DefaultSsResponse<Balance>(
            data: null,
            error: response.error,
            success: false
        );
      }

    } catch (exception) {
      LoggerUtil.error('addCustomToken error: ${exception.toString()}');
      return DefaultSsResponse.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse<ContractInfo>> getContractInfo({required Map<String, dynamic> params}) async {
    try {
      final Map responseJson = await _baseAPI.request(
        manager: ApiManager(ApiType.getContractInfo),
        queryParams: params,
        isUseAccessToken: true,
      );

      // final response = DefaultWalletResponse.fromJson(responseJson);
      ContractInfo contractInfo = ContractInfo.fromJson(responseJson);
      return DefaultSsResponse<ContractInfo>(
          data: contractInfo,
          success: true
      );
    } catch (exception) {
      LoggerUtil.error('getContractInfo error: ${exception.toString()}');
      return DefaultSsResponse.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse<Wallet>> updateName({required String name, required String walletId}) async {
    try {
      //encrypt param
      final String jsonData = jsonEncode({
        "name": name,
      });
      final b64key = encrypt.Key.fromBase64(encryptionKey);
      final fernet = encrypt.Fernet(b64key);
      final encryptor = encrypt.Encrypter(fernet);
      final encrypted = encryptor.encrypt(jsonData);

      final Map responseJson = await _baseAPI.request(
          manager: ApiManager(ApiType.sendToken),
          optionalPath: '/$walletId/update',
          bodyParams: {
            'encrypted': encrypted.base64,
          }
      );

      final response = DefaultSsResponse.fromMap(responseJson);
      if (response.success && response.data != null) {
        final result = Wallet.fromJson(response.data);
        return DefaultSsResponse<Wallet>(
            data: result,
            error: null,
            success: true
        );
      } else {
        return DefaultSsResponse<Wallet>(
            data: null,
            error: response.error,
            success: false
        );
      }
    } catch (exception) {
      return DefaultSsResponse.withError(
        SsError(message: exception.toString()),
      );
    }
  }

  Future<DefaultSsResponse<TransactionHash>> sendNft({required String tokenContract, required int tokenId, required String address, required String walletId}) async {
    try {
      //encrypt param
      final String jsonData = jsonEncode({
        "token_contract": tokenContract,
        "token_id": tokenId,
        "receiver_address": address,
      });
      final b64key = encrypt.Key.fromBase64(encryptionKey);
      final fernet = encrypt.Fernet(b64key);
      final encryptor = encrypt.Encrypter(fernet);
      final encrypted = encryptor.encrypt(jsonData);

      final Map responseJson = await _baseAPI.request(
          manager: ApiManager(ApiType.sendToken),
          optionalPath: '/$walletId/nft/send',
          bodyParams: {
            'encrypted': encrypted.base64,
          }
      );
      // return DefaultSsResponse.fromMap(responseJson);
      final response = DefaultSsResponse.fromMap(responseJson);
      if (response.success && response.data != null) {
        final data = TransactionHash.fromJson(response.data);
        return DefaultSsResponse<TransactionHash>(
            data: data,
            success: true
        );
      } else {
        return DefaultSsResponse<TransactionHash>(
            error: response.error,
            success: false
        );
      }
    } catch (exception) {
      return DefaultSsResponse.withError(
        SsError(message: exception.toString()),
      );
    }
  }
}