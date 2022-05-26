import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/data/event_bus/event_bus_event.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/data/repository/singnft_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/db/db_manager.dart';
import 'package:sing_app/utils/logger_util.dart';
import '../../application.dart';
import 'change_wallet_name_event.dart';
import 'change_wallet_name_state.dart';

class ChangeWalletNameBloc extends Bloc<ChangeWalletNameEvent, ChangeWalletNameState> {

  final BaseWalletRepository walletRepository;
  final BaseSingNftRepository singNftRepository;
  String currentName;
  Wallet wallet;

  ChangeWalletNameBloc({
    required this.walletRepository,
    required this.singNftRepository,
    required this.currentName,
    required this.wallet,
  }) : super(ChangeWalletNameStateInitial()){
    on<ChangeWalletNameEventStart>((event, emit) async {
      await _mapChangeWalletNameEventStartToState(emit);
    });
    on<ChangeWalletNameEventSaving>((event, emit) async {
      await _mapChangeWalletNameEventSavingToState(event, emit);
    });
  }
  Future<void> _mapChangeWalletNameEventStartToState(Emitter<ChangeWalletNameState> emit) async {
    
  }

  Future<void> _mapChangeWalletNameEventSavingToState(ChangeWalletNameEventSaving event, Emitter<ChangeWalletNameState> emit) async {
    emit(ChangeWalletNameStateSaving());
    String customName = event.name.trim();
    if(customName.isEmpty){
      customName = wallet.description;
    }
    var success = false;
    var errorMessage = '';
    if(wallet.isLocal){
      LoggerUtil.debug('change local wallet');
      success = await DbManager.instance.updateWalletName(name: customName, walletId: wallet.id);
      if(success){
        wallet.description = customName;
      } else {
        errorMessage = l('Error saving wallet');
      }
    } else {
      LoggerUtil.debug('change online wallet');
      final response = await walletRepository.updateName(name: customName, walletId: wallet.id);
      success = response.success && response.data != null;
      if(success){
        wallet.description = response.data!.description;
      } else {
        errorMessage = response.error?.message ?? l('Error saving wallet');
      }
    }
    if (success) {
      App.instance.eventBus.fire(EventBusChangeWalletNameSuccessful(
          walletId: wallet.id, name: customName));
      emit(ChangeWalletNameStateSaved());
    } else {
      emit(ChangeWalletNameStateErrorSaving(message: errorMessage));
    }
  }
}