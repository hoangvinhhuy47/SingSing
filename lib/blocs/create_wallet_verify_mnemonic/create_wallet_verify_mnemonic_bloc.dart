import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/create_wallet_verify_mnemonic/create_wallet_verify_mnemonic_event.dart';
import 'package:sing_app/blocs/create_wallet_verify_mnemonic/create_wallet_verify_mnemonic_state.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/data/models/support_chain.dart';
import 'package:sing_app/db/db_manager.dart';
import 'package:sing_app/utils/import_wallet_util.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/token_util.dart';



class CreateWalletVerifyMnemonicBloc extends Bloc<CreateWalletVerifyMnemonicEvent, CreateWalletVerifyMnemonicState> {
  final String mnemonic;
  final SupportChain chain;

  CreateWalletVerifyMnemonicBloc({required this.mnemonic, required this.chain}) : super(CreateWalletVerifyMnemonicStateInitial()){
    on<CreateWalletVerifyMnemonicEventStarted>(_handleCreateWalletVerifyMnemonicEventStarted);
    on<CreateWalletVerifyMnemonicEventSaving>(_handleCreateWalletVerifyMnemonicEventSaving);
  }

  Future<void> _handleCreateWalletVerifyMnemonicEventStarted(CreateWalletVerifyMnemonicEvent event, Emitter<CreateWalletVerifyMnemonicState> emit) async {
    LoggerUtil.info('mnemonic: $mnemonic');
    emit(CreateWalletVerifyMnemonicStateStarted());
  }

  Future<void> _handleCreateWalletVerifyMnemonicEventSaving(CreateWalletVerifyMnemonicEvent event, Emitter<CreateWalletVerifyMnemonicState> emit) async {
    emit(CreateWalletVerifyMnemonicStateSaving());
    final privateKey = TokenUtil.getPrivateKey(mnemonic);
    LoggerUtil.info('privateKey: $privateKey');
    final address = await TokenUtil.getPublicAddress(privateKey);
    LoggerUtil.info('address: $address');

    final walletId = await DbManager.instance.insertWallet(name: l('My wallet'), mnemonic: mnemonic, privateKey: privateKey, address: address.toString(), secretType: chain.secretType);

    LoggerUtil.info('new wallet id: $walletId');
    if(walletId.isNotEmpty){
      await ImportWalletUtil.addChainBalance(walletId: walletId, walletAddress: address.toString(), secretType: chain.secretType);
      if(chain.secretType == secretTypeBsc){
        await ImportWalletUtil.addSingSingBalance(walletId: walletId, walletAddress: address.toString());
      }
      emit(CreateWalletVerifyMnemonicStateSaved());
    } else {
      emit(CreateWalletVerifyMnemonicStateErrorSaving(message: l('Error creating new wallet')));
    }
  }



  bool isValid(String text) {
    return text.trim() == mnemonic;
  }
}
