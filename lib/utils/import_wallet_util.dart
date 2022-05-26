import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/db/db_manager.dart';
import 'package:sing_app/utils/token_util.dart';
import 'package:web3dart/web3dart.dart';

abstract class ImportWalletUtil {
  static String randomRpc(){
    return  (AppConfig.instance.values.rpcUrls.toList()..shuffle()).first;
  }
  static String randomEthRpc(){
    return  (AppConfig.instance.values.ethRpcUrls.toList()..shuffle()).first;
  }
  static Future<bool> addChainBalance({
    required String walletId,
    required String walletAddress,
    required String secretType,
  }) async{
    final balance = await TokenUtil.getBalance(walletAddress: walletAddress, rpcUrl: randomRpc());
    if(balance == null){
      return false;
    }
    final symbol = AppConfig.instance.values.supportChains[secretType]?.symbol ?? tokenSymbolBnb;
    final dBalance = balance.getValueInUnit(EtherUnit.ether).toDouble();
    final dRawBalance = balance.getValueInUnit(EtherUnit.wei).toDouble();
    await DbManager.instance.insertBalance(
        walletId: walletId,
        tokenAddress: null,
        secretType: secretType,
        balance: dBalance,
        rawBalance: dRawBalance,
        gasBalance: dBalance,
        rawGasBalance: dRawBalance,
        symbol: symbol,
        gasSymbol: symbol,
        decimals: 18
    );
    return true;
  }

  static Future<bool> addTokenBalance({
    required String walletId,
    required String walletAddress,
    required String contractAddress,
    required String symbol,
  }) async{
    final secretType = secretTypeBsc;
    if(walletAddress.isEmpty || contractAddress.isEmpty){
      return false;
    }
    final balance = await TokenUtil.getTokenBalance(walletAddress: walletAddress, contractAddress: contractAddress, rpcUrl: randomRpc());
    if(balance == null){
      return false;
    }
    final dBalance = balance.getValueInUnit(EtherUnit.ether).toDouble();
    final dRawBalance = balance.getValueInUnit(EtherUnit.wei).toDouble();
    await DbManager.instance.insertBalance(
        walletId: walletId,
        tokenAddress: contractAddress,
        secretType: secretType,
        balance: dBalance,
        rawBalance: dRawBalance,
        gasBalance: dBalance,
        rawGasBalance: dRawBalance,
        symbol: symbol,
        gasSymbol: symbol,
        decimals: 18
    );
    return true;
  }
  static Future<bool> addSingSingBalance({
    required String walletId,
    required String walletAddress,
  }) async {
    return await addTokenBalance(walletId: walletId, walletAddress: walletAddress, contractAddress: AppConfig.instance.values.singSingContractAddress, symbol: 'SING');
  }
}