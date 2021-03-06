import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/data/models/wallet.dart';
import 'package:sing_app/data/repository/singnft_repository.dart';
import 'package:sing_app/data/repository/wallet_repository.dart';
import 'package:sing_app/event_bus/event_bus_event.dart';
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
    final response = await walletRepository.updateName(name: customName, walletId: wallet.id);
    if(response.success && response.data != null){
      wallet.description = response.data!.description;
      App.instance.eventBus.fire(EventBusChangeWalletNameSuccessful(walletId: wallet.id, name: customName));
      emit(ChangeWalletNameStateSaved());
    } else {
      emit(ChangeWalletNameStateErrorSaving(message: response.error?.message ?? l('Error saving wallet')));
    }
  }
}