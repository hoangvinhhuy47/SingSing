import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_token_event.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_token_state.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/data/repository/covalent_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/utils/logger_util.dart';
import '../../application.dart';

class WalletDetailTokenBloc
    extends Bloc<WalletDetailTokenEvent, WalletDetailTokenState> {
  final BaseWalletRepository walletRepository;
  final BaseCovalentRepository covalentRepository;

  final Wallet wallet;
  // List<Balance> balances = [];
  Map<String, double> priceTable = {};
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
      if(wallet.id == event.wallletId) {
        wallet.description = event.name;
        emit(ChangeWalletNameSuccessfulState(event.wallletId, event.name));
      }
    });
  }

  Future<void> _mapWalletDetailTokenEventStartToState(Emitter<WalletDetailTokenState> emit) async {
    //token tab
    emit(WalletDetailTokenStateLoading());
    //fetch balances
    if(_dataLoaded){
      emit(WalletDetailTokenStateLoaded());
      return;
    }

    final response = await walletRepository.getTokenBalances(wallet.id);
    if (response.success && response.data != null) {

      App.instance.updateBalances(wallet.id, response.data!);
    } else {
      LoggerUtil.error('error getting balance ${response.error?.message}');
    }

    emit(WalletDetailTokenStateLoaded());

    //get wallet balance btc and dollar
    final List<String> tokenSymbols = [];
    tokenSymbols.add('BTC');
    if(priceTable[wallet.balance!.symbol] == null){
      tokenSymbols.add(wallet.balance!.symbol.toUpperCase());
    }
    for (final token in App.instance.availableBalances) {
      if (priceTable[token.symbol.toUpperCase()] != null) {
        continue;
      }
      tokenSymbols.add(token.symbol.toUpperCase());
    }
    final responseTokenPrice = await covalentRepository.fetchTokenPrice(tokenSymbols, 'USD');
    if (!responseTokenPrice.isError && responseTokenPrice.data != null) {
      for(final item in responseTokenPrice.data!){
        var symbol = item.contractTickerSymbol ?? '';
        final value = item.quoteRate ?? 0.0;
        priceTable[symbol] = value;
        if(symbol == 'WBTC'){
          priceTable['BTC'] = value;
        } else if(symbol == 'WETH'){
          priceTable['ETH'] = value;
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
