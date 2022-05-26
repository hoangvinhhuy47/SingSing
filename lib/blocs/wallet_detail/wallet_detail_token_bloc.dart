import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_token_event.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_token_state.dart';
import 'package:sing_app/data/models/wallet.dart' as ss;
import 'package:sing_app/data/repository/covalent_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/db/db_manager.dart';
import 'package:sing_app/utils/import_wallet_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/token_util.dart';
import 'package:web3dart/web3dart.dart';
import '../../application.dart';

class WalletDetailTokenBloc
    extends Bloc<WalletDetailTokenEvent, WalletDetailTokenState> {
  final BaseWalletRepository walletRepository;
  final BaseCovalentRepository covalentRepository;

  final ss.Wallet wallet;
  bool _dataLoaded = false;
  
  WalletDetailTokenBloc({
    required this.walletRepository,
    required this.wallet,
    required this.covalentRepository,
  }) : super(WalletDetailTokenStateLoading()){
    on<WalletDetailTokenEventStart>((event, emit) async {
      await _mapWalletDetailTokenEventStartToState(emit);
    });
    on<WalletDetailTokenEventReload>((event, emit) async {
      await _mapWalletDetailTokenEventReloadToState(emit);
    });
    on<WalletDetailTokenPriceUpdate>((event, emit) async {
      await _mapWalletDetailTokenPriceUpdateToState(emit);
    });

    on<ChangeWalletNameSuccessful>((event, emit) async {
      if(wallet.id == event.walletId) {
        wallet.description = event.name;
        emit(ChangeWalletNameSuccessfulState(event.walletId, event.name));
      }
    });
  }

  Future<void> _mapWalletDetailTokenEventStartToState(Emitter<WalletDetailTokenState> emit) async {
    //token tab
    emit(WalletDetailTokenStateLoading());

    // /// test
    // if(wallet.isLocal){
    //   double singSingBalance = await TokenUtil.getTokenBalance(walletAddress: '0x9427Bea33F108c7951572f5b1597760355bD0578',
    //       contractAddress: '0xEc3b10C74Fa75576874151872F3D002134E48B37',
    //       rpcUrl:  (AppConfig.instance.values.rpcUrls.toList()..shuffle()).first);
    //   LoggerUtil.info('singSingBalance: $singSingBalance');
    //   double walletBnbBalance = await TokenUtil.getBalance(walletAddress: '0x9427Bea33F108c7951572f5b1597760355bD0578',
    //       rpcUrl:  (AppConfig.instance.values.rpcUrls.toList()..shuffle()).first);
    //   LoggerUtil.info('walletBnbBalance: $walletBnbBalance');
    // }

    //fetch balances
    if(_dataLoaded){
      emit(WalletDetailTokenStateLoaded());
      return;
    }

    if(wallet.isLocal){
      final tokens = await DbManager.instance.getBalances(wallet.id);
      if (tokens.isNotEmpty) {
        //reload balance
        final hiddenContractAddress =
        await DbManager.instance.getListHideToken(wallet.id);
        for(final token in tokens){
          if(token.tokenAddress != null && !hiddenContractAddress.contains(token.tokenAddress)){
            LoggerUtil.info('Update token: ${token.symbol} ${token.tokenAddress}');
            final balance = await TokenUtil.getTokenBalance(
                walletAddress: wallet.address,
                contractAddress: token.tokenAddress!,
                rpcUrl: ImportWalletUtil.randomRpc()
            );
            if(balance != null){
              final dBalance = balance.getValueInUnit(EtherUnit.ether).toDouble();
              final dRawBalance = balance.getValueInUnit(EtherUnit.wei).toDouble();
              if(dBalance != token.balance){
                LoggerUtil.info('Update db');
                await DbManager.instance.updateBalance(
                    walletId: wallet.id,
                    tokenAddress: token.tokenAddress!,
                    gasBalance: dBalance,
                    rawGasBalance: dRawBalance,
                    balance: dBalance,
                    rawBalance: dRawBalance);
                token.balance = dBalance;
                token.rawBalance =dRawBalance;
              }
            }
          }
        }
        //refresh token balances
        App.instance.updateBalances(wallet.id, tokens);
      }
    } else {
      final response = await walletRepository.getTokenBalances(wallet.id);
      if (response.success && response.data != null) {
        App.instance.updateBalances(wallet.id, response.data!);
      } else {
        LoggerUtil.error('error getting balance ${response.error}');
      }
    }

    emit(WalletDetailTokenStateLoaded());

    //get wallet balance btc and dollar
    final List<String> tokenSymbols = [];
    tokenSymbols.add('BTC');
    if(App.instance.priceTable[wallet.balance!.symbol] == null){
      tokenSymbols.add(wallet.balance!.symbol.toUpperCase());
    }
    for (final token in App.instance.availableBalances) {
      if (App.instance.priceTable[token.symbol.toUpperCase()] != null) {
        continue;
      }
      tokenSymbols.add(token.symbol.toUpperCase());
    }
    final responseTokenPrice = await covalentRepository.fetchTokenPrice(tokenSymbols, 'USD');
    if (!responseTokenPrice.isError && responseTokenPrice.data != null) {
      for(final item in responseTokenPrice.data!){
        var symbol = item.contractTickerSymbol ?? '';
        final value = item.quoteRate ?? 0.0;
        App.instance.priceTable[symbol] = value;
        if(symbol == 'WBTC'){
          App.instance.priceTable['BTC'] = value;
        } else if(symbol == 'WETH'){
          App.instance.priceTable['ETH'] = value;
        }
      }
    }
    emit(WalletDetailTokenStatePriceUpdate());
    _dataLoaded = true;
  }

  Future<void> _mapWalletDetailTokenEventReloadToState(Emitter<WalletDetailTokenState> emit) async {
    _dataLoaded = false;
    await _mapWalletDetailTokenEventStartToState(emit);
  }

  Future<void> _mapWalletDetailTokenPriceUpdateToState(Emitter<WalletDetailTokenState> emit) async {
    emit(WalletDetailTokenStatePriceUpdate());
  }

  bool isDataLoaded(){
    return _dataLoaded;
  }
}
