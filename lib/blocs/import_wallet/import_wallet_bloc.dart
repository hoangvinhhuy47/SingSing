import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/import_wallet/import_wallet_event.dart';
import 'package:sing_app/blocs/import_wallet/import_wallet_state.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/support_chain.dart';
import 'package:sing_app/db/db_constants.dart';
import 'package:sing_app/db/db_manager.dart';
import 'package:sing_app/utils/import_wallet_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/token_util.dart';



class ImportWalletBloc extends Bloc<ImportWalletEvent, ImportWalletState> {
  final SupportChain chain;
  int _selectedTabIndex = 0;
  int walletCount = 0;

  ImportWalletBloc(this.chain) : super(ImportWalletStateInitial()){
    on<ImportWalletEventStarted>(_handleImportWalletEventStarted);
    on<ImportWalletEventSaving>(_handleImportWalletEventSaving);
    on<ImportWalletEventTabBarPressed>(_handleTabBarPressed);
  }

  Future<void> _handleImportWalletEventStarted(ImportWalletEvent event, Emitter<ImportWalletState> emit) async {
    walletCount = await DbManager.instance.countWallet(secretType: chain.secretType);
    emit(ImportWalletStateStarted());
  }

  Future<void> _handleImportWalletEventSaving(ImportWalletEventSaving event, Emitter<ImportWalletState> emit) async {
    emit(ImportWalletStateSaving());
    final secretType = chain.secretType;
    final importMethod = _selectedTabIndex == 0 ? WalletImportMethod.mnemonic : WalletImportMethod.privateKey;
    final data = event.data.trim();
    var privateKey = "";
    var mnemonic = TokenUtil.mnemonicWords(data).join(' ');
    if(importMethod == WalletImportMethod.mnemonic){
      privateKey = TokenUtil.getPrivateKey(mnemonic);
    } else {
      privateKey = data;
    }
    LoggerUtil.info('privateKey: $privateKey');
    if(privateKey.isEmpty){
      emit(ImportWalletStateErrorSaving(message: l('Error importing wallet')));
      return;
    }
    final address = await TokenUtil.getPublicAddress(privateKey);
    LoggerUtil.info('address: $address');
    if(address.toString().isEmpty){
      emit(ImportWalletStateErrorSaving(message: l('Error importing wallet')));
      return;
    }

    //test get balance before importing
    try{
      final rpcUrl = ImportWalletUtil.randomRpc();
      LoggerUtil.info('getting balance from $rpcUrl');
      final balance = await TokenUtil.getBalance(walletAddress: address.toString(), rpcUrl: rpcUrl);
      LoggerUtil.info('balance: $balance');
    } catch(exc){
      LoggerUtil.error('error getting wallet balance: $exc');
      emit(ImportWalletStateErrorSaving(message: l('Error importing wallet')));
      return;
    }

    final walletId = await DbManager.instance.insertWallet(
        name: event.name.trim(),
        mnemonic: mnemonic,
        privateKey: privateKey,
        address: address.toString(),
        secretType: secretType
    );

    await ImportWalletUtil.addChainBalance(walletId: walletId, walletAddress: address.toString(), secretType: secretType);
    if(secretType == secretTypeBsc){
      await ImportWalletUtil.addSingSingBalance(walletId: walletId, walletAddress: address.toString());
    }

    LoggerUtil.info('new wallet id: $walletId');
    if(walletId.isNotEmpty){
      emit(ImportWalletStateSaved());
    } else {
      emit(ImportWalletStateErrorSaving(message: l('Error importing wallet')));
    }
  }

  int get selectedTabIndex => _selectedTabIndex;

  FutureOr<void> _handleTabBarPressed(ImportWalletEventTabBarPressed event, Emitter<ImportWalletState> emit) async {
    _selectedTabIndex = event.index;
    emit(ImportWalletStateTabBarChanged(event.index));
  }
}
