import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sing_app/blocs/wallet/wallet_screen_event.dart';
import 'package:sing_app/blocs/wallet/wallet_screen_state.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/db/db_manager.dart';
import 'package:sing_app/oauth2/oauth2_manager.dart';
import 'package:sing_app/utils/import_wallet_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/token_util.dart';
import 'package:web3dart/web3dart.dart' as web3;

class WalletScreenBloc extends Bloc<WalletScreenEvent, WalletScreenState> {
  List<Wallet> wallets = [];
  List<Wallet> localWallets = [];

  final BaseWalletRepository walletRepository;
  WalletScreenBloc({
    required this.walletRepository,
  }) : super(WalletScreenStateInitial()){

    on<WalletScreenEventStarted>((event, emit) async {
      emit(WalletScreenStateLoading(showLoading: event.isRefreshing));
      await _mapWalletScreenEventStartedToState(emit);
    });

    on<WalletScreenShowLoadingEvent>((event, emit) async {
      emit(WalletScreenStateLoading(showLoading: event.isLoading));
    });

    on<WalletScreenEventReload>((event, emit) async {
      await _mapWalletScreenEventReloadToState(emit);
    });

    on<ChangeWalletNameSuccessful>((event, emit) async {
      for(Wallet wallet in wallets) {
        if(wallet.id == event.walletId) {
          wallet.description = event.name;
          emit(ChangeWalletNameSuccessfulState(walletId: event.walletId, name: event.name));
        }
      }
      for(Wallet wallet in localWallets) {
        if(wallet.id == event.walletId) {
          wallet.description = event.name;
          emit(ChangeWalletNameSuccessfulState(walletId: event.walletId, name: event.name));
        }
      }
    });
  }

  Future<void> _mapWalletScreenEventReloadToState(Emitter<WalletScreenState> emit) async {
    emit(const WalletScreenStateLoading(showLoading: false));
    await _mapWalletScreenEventStartedToState(emit);
  }

  Future<void> _mapWalletScreenEventStartedToState(Emitter<WalletScreenState> emit) async {
    //get local wallets
    localWallets = await DbManager.instance.getWallets();

    final user = await Oauth2Manager.instance.getUserApp();
    if (user != null) {
      final walletResponse = await walletRepository.getWallets();
      if(walletResponse.success && walletResponse.data != null){
        wallets = walletResponse.data!;
      }
      emit(const WalletScreenStateUserInfoFetched(loggedIn: true));
    } else {
      wallets.clear();
      emit(const WalletScreenStateUserInfoFetched(loggedIn: false));
    }

    if(localWallets.isNotEmpty){
      //fetch balance
      final Map<String, double> addresses = {};
      for (var w in localWallets) {
        if(addresses[w.address] == null){
          web3.EtherAmount? balance;
          if(w.secretType == secretTypeBsc){
            final rpc = ImportWalletUtil.randomRpc();
            balance = await TokenUtil.getBalance(walletAddress: w.address, rpcUrl: rpc);
          } else if(w.secretType == secretTypeEth){
            final rpc = ImportWalletUtil.randomEthRpc();
            balance = await TokenUtil.getBalance(walletAddress: w.address, rpcUrl: rpc);
          }
          if(balance != null){
            final dBalance = balance.getValueInUnit(web3.EtherUnit.ether).toDouble();
            final dRawBalance = balance.getValueInUnit(web3.EtherUnit.wei).toDouble();
            if(dBalance != w.balance?.balance){
              LoggerUtil.debug('new balance Value: $dBalance');
              w.balance?.balance = dBalance;
              w.balance?.rawBalance = dRawBalance;
              await DbManager.instance.updateWalletBalance(walletId: w.id, balance: dBalance, rawBalance: dRawBalance);
              emit(WalletScreenStateBalanceUpdated(walletAddress: w.address, balance: dBalance));
            }
          }
        }
      }
    }
  }

  Wallet getWallet(int index){
    final localCount = localWallets.length;
    if(index < localCount){
      return localWallets[index];
    } else {
      return wallets[index - localCount];
    }
  }
}
