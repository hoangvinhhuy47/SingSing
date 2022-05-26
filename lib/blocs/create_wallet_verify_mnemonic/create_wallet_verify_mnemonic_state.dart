import 'package:equatable/equatable.dart';

abstract class CreateWalletVerifyMnemonicState extends Equatable {
  const CreateWalletVerifyMnemonicState();

  @override
  List<Object> get props => [];
}

class CreateWalletVerifyMnemonicStateInitial extends CreateWalletVerifyMnemonicState {}
class CreateWalletVerifyMnemonicStateStarted extends CreateWalletVerifyMnemonicState {}
class CreateWalletVerifyMnemonicStateSaving extends CreateWalletVerifyMnemonicState {}
class CreateWalletVerifyMnemonicStateSaved extends CreateWalletVerifyMnemonicState {}
class CreateWalletVerifyMnemonicStateErrorSaving extends CreateWalletVerifyMnemonicState {
  final String message;
  const CreateWalletVerifyMnemonicStateErrorSaving({
    required this.message
  });

  @override
  List<Object> get props => [message];
}