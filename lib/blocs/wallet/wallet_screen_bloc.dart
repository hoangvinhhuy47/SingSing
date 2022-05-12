import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:sing_app/blocs/wallet/wallet_screen_event.dart';
import 'package:sing_app/blocs/wallet/wallet_screen_state.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/oauth2/oauth2_manager.dart';

class WalletScreenBloc extends Bloc<WalletScreenEvent, WalletScreenState> {
  List<Wallet> wallets = [];

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
        if(wallet.id == event.wallletId) {
          wallet.description = event.name;
          emit(ChangeWalletNameSuccessfulState(event.wallletId, event.name));
        }
      }
    });


  }

  Future<void> _mapWalletScreenEventReloadToState(Emitter<WalletScreenState> emit) async {
    emit(const WalletScreenStateLoading(showLoading: false));
    await _mapWalletScreenEventStartedToState(emit);
  }

  Future<void> _mapWalletScreenEventStartedToState(Emitter<WalletScreenState> emit) async {
    final user = await Oauth2Manager.instance.getUser();

    if (user != null) {
      final walletResponse = await walletRepository.getWallets();
      if(walletResponse.success && walletResponse.data != null){
        wallets = walletResponse.data!;
      }
      emit(const WalletScreenStateUserInfoFetched(loggedIn: true));
      return;
    } else {
      emit(const WalletScreenStateUserInfoFetched(loggedIn: false));
    }
  }
}
