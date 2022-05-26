import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_event.dart';
import 'package:sing_app/blocs/wallet_detail/wallet_detail_state.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:collection/collection.dart';
import 'package:sing_app/utils/logger_util.dart';


class WalletDetailBloc extends Bloc<WalletDetailEvent, WalletDetailState> {
  bool _showBalance = true;
  int _selectedTabIndex = 0;
  final BaseWalletRepository walletRepository;
  Wallet wallet;
  bool nameChanged = false;

  WalletDetailBloc({
    required this.walletRepository,
    required this.wallet,
  }) : super(WalletDetailStateLoading()){
    on<WalletDetailEventShowHideBalance>((event, emit) async {
      await _mapAppShowHideBalanceToState(event, emit);
    });
    on<WalletDetailEventStart>((event, emit) async {
      await _mapTabBarPressedEventToState(const WalletDetailTabBarPressedEvent(0), emit);
    });
    on<WalletDetailTabBarPressedEvent>((event, emit) async {
      await _mapTabBarPressedEventToState(event, emit);
    });
    on<WalletDetailEventReload>((event, emit) async {
      await _mapWalletDetailEventReloadToState(emit);
    });
  }

  Future<void> _mapWalletDetailEventReloadToState(Emitter<WalletDetailState> emit) async {
    nameChanged = true;
    emit(WalletDetailStateLoading());

    //reload wallet
    final response = await walletRepository.getWallets();
    if(response.success && response.data != null){
      final updatedWallet = response.data?.firstWhereOrNull((element) => element.id == wallet.id);
      if(updatedWallet != null){
        wallet = updatedWallet;
      }
    }
    await _mapTabBarPressedEventToState(const WalletDetailTabBarPressedEvent(0), emit);
  }

  Future<void> _mapAppShowHideBalanceToState(WalletDetailEventShowHideBalance event, Emitter<WalletDetailState> emit) async {
    _showBalance = event.show;
    emit(WalletDetailStateShowHideBalance(_showBalance));
  }


  Future<void> _mapTabBarPressedEventToState(WalletDetailTabBarPressedEvent event, Emitter<WalletDetailState> emit) async {
    _selectedTabIndex = event.index;
    if(_selectedTabIndex == 0){
      LoggerUtil.info('wallet: ${wallet.toJson()}');
      // final wc = web3.WalletConnectProvider.binance();
      // LoggerUtil.info('wallet connected: $wc');
    }

    emit(WalletDetailTabBarChanged(event.index));
  }

  bool showBalance(){
    return _showBalance;
  }

  int selectedTabIndex(){
    return _selectedTabIndex;
  }
}
