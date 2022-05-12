import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/setting_wallet/setting_wallet_event.dart';
import 'package:sing_app/blocs/setting_wallet/setting_wallet_state.dart';
import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/data/repository/singnft_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/db/db_manager.dart';
import 'package:sing_app/oauth2/oauth2_manager.dart';
import 'package:sing_app/utils/logger_util.dart';
import '../../application.dart';

class SettingWalletBloc extends Bloc<SettingWalletEvent, SettingWalletState> {
  final BaseWalletRepository walletRepository;
  final BaseSingNftRepository singNftRepository;
  final Wallet wallet;


  bool _reloaded = false;
  bool get reloaded => _reloaded;

  List<Balance> _balances = [];
  List<Balance> get balances => _balances;

  SettingWalletBloc({
    required this.walletRepository,
    required this.singNftRepository,
    required this.wallet,
  }) : super(SettingWalletStateInitial()){
    on<SettingWalletEventStart>((event, emit) async {
      await _mapSettingWalletEventStartToState(emit);
    });
    on<SettingWalletEventReload>((event, emit) async {
      await _mapSettingWalletEventReloadToState(emit);
    });
    on<OnTextSearchChangedEvent>((event, emit) async {
      await _mapOnTextSearchChangedEventToState(event, emit);
    });
    on<OnBalanceCheckedChangeEvent>((event, emit) async {
      await _mapOnBalanceCheckedChangeEventToState(event, emit);
    });
  }

  Future<void> _mapSettingWalletEventStartToState(Emitter<SettingWalletState> emit) async {
    // _balances = App.instance.allBalances;
    emit(SettingWalletStateInitial());
    _balances = [];

    List<String> hiddenContractAddress = await DbManager.instance.getListHideToken(wallet.id);
    for (Balance item in App.instance.allBalances) {
      bool isHidden = false;
      for (String contractAddress in hiddenContractAddress) {
        if (item.tokenAddress?.isNotEmpty ?? false) {
          if (item.tokenAddress == contractAddress) {
            isHidden = true;
            break;
          }
        } else {
          if (item.secretType == contractAddress) {
            isHidden = true;
            break;
          }
        }
      }
      item.isHidden = isHidden;
      _balances.add(item);

      emit(SettingWalletStateLoaded());
    }
  }

  Future<void> _mapSettingWalletEventReloadToState(Emitter<SettingWalletState> emit) async {
    _reloaded = true;
    final user = await Oauth2Manager.instance.getUser();
    if(user != null){
      emit(SettingWalletStateInitial());
      emit(SettingWalletStateLoaded());
    }
  }

  Future<void> _mapOnTextSearchChangedEventToState(OnTextSearchChangedEvent event, Emitter<SettingWalletState> emit) async {
    emit(SettingWalletStateInitial());
    _balances = [];
    for(Balance item in App.instance.allBalances) {
      if(item.symbol.toLowerCase().contains(event.text.toLowerCase())) {
        _balances.add(item);
      }
    }

    emit(SettingWalletStateLoaded());
  }

  Future<void> _mapOnBalanceCheckedChangeEventToState(OnBalanceCheckedChangeEvent event, Emitter<SettingWalletState> emit) async {
    emit(SettingWalletStateInitial());
    if(!event.isChecked) {
      await DbManager.instance.hideBalance(event.balance);
    } else {
      DbManager.instance.unHideBalance(event.balance);
    }

    List<String> hiddenContractAddress =  await DbManager.instance.getListHideToken(event.balance.walletId);
    App.instance.availableBalances = [];

    for(Balance item in App.instance.allBalances) {
      bool isHidden = false;
      for(String contractAddress in hiddenContractAddress) {
        if(item.tokenAddress?.isNotEmpty ?? false) {
          if(item.tokenAddress == contractAddress) {
            isHidden = true;
            break;
          }
        } else {
          if(item.secretType == contractAddress) {
            isHidden = true;
            break;
          }
        }
      }
      item.isHidden = isHidden;
      if(!isHidden) App.instance.availableBalances.add(item);

    }
    _balances = App.instance.allBalances;
    _reloaded = true;

    emit(SettingWalletStateLoaded());
  }

}