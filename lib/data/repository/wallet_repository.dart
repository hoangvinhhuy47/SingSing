
import 'package:sing_app/data/data_provider/base_api.dart';
import 'package:sing_app/data/data_provider/wallet_api_provider.dart';
import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/data/models/contract_info.dart';
import 'package:sing_app/data/models/network_gas_fee.dart';
import 'package:sing_app/data/models/transaction_hash.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/data/response/ss_response.dart';

abstract class BaseWalletRepository {
  Future<DefaultSsResponse<List<Wallet>>> getWallets();
  Future<DefaultSsResponse<List<Balance>>> getTokenBalances(String walletId);
  // Future<DefaultSsResponse<int>> getWalletNfts(String walletId);
  Future<DefaultSsResponse> getTokenPrice(String symbol);
  Future<DefaultSsResponse<NetworkGasFee>> calculateNetworkGasFee({required double price, required String priceSymbol, required String walletId});
  Future<DefaultSsResponse<TransactionHash>> sendToken({required String tokenContract, required double amount, required String address, required String walletId});


  Future<DefaultSsResponse<Balance>> addCustomToken(String walletId, Map<String, dynamic> params);
  Future<DefaultSsResponse<Wallet>> updateName({required String name, required String walletId});
  Future<DefaultSsResponse<ContractInfo>> getContractInfo(Map<String, dynamic> params);

  Future<DefaultSsResponse<TransactionHash>> sendNft({required String tokenContract, required int tokenId, required String address, required String walletId});
}

class WalletRepository extends BaseWalletRepository {
  late WalletApiProvider _walletApiProvider;

  WalletRepository(BaseAPI baseAPI) {
    _walletApiProvider = WalletApiProvider(baseAPI);
  }

  @override
  Future<DefaultSsResponse<List<Wallet>>> getWallets() async{
    return _walletApiProvider.getWallets();
  }

  @override
  Future<DefaultSsResponse<List<Balance>>> getTokenBalances(String walletId) async {
    return _walletApiProvider.getWalletTokenBalances(walletId);
  }

  // @override
  // Future<DefaultSsResponse<int>> getWalletNfts(String walletId) async {
  //   return _walletApiProvider.getWalletNfts(walletId);
  // }

  @override
  Future<DefaultSsResponse> getTokenPrice(String symbol, {String to = 'USDT'}) async {
    return _walletApiProvider.getTokenPrice(symbol, to: to);
  }

  @override
  Future<DefaultSsResponse<NetworkGasFee>> calculateNetworkGasFee({required double price, required String priceSymbol, required String walletId}) async {
    return _walletApiProvider.calculateNetworkGasFee(price: price, priceSymbol: priceSymbol, walletId: walletId);
  }

  @override
  Future<DefaultSsResponse<TransactionHash>> sendToken({required String tokenContract, required double amount, required String address, required String walletId}) async {
    return _walletApiProvider.sendToken(tokenContract: tokenContract, amount: amount, address: address, walletId: walletId);
  }

  @override
  Future<DefaultSsResponse<Balance>> addCustomToken(String walletId, Map<String, dynamic> params) {
    return _walletApiProvider.addCustomToken(walletId: walletId, params: params);
  }

  @override
  Future<DefaultSsResponse<ContractInfo>> getContractInfo(Map<String, dynamic> params) {
    return _walletApiProvider.getContractInfo(params: params);
  }

  @override
  Future<DefaultSsResponse<Wallet>> updateName({required String name, required String walletId}) {
    return _walletApiProvider.updateName(name: name, walletId: walletId);
  }

  @override
  Future<DefaultSsResponse<TransactionHash>> sendNft({required String tokenContract, required int tokenId, required String address, required String walletId}){
    return _walletApiProvider.sendNft(tokenContract: tokenContract, tokenId: tokenId, address: address, walletId: walletId);
  }
}

