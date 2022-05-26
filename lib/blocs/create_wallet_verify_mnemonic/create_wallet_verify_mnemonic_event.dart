import 'package:equatable/equatable.dart';

abstract class CreateWalletVerifyMnemonicEvent extends Equatable {
  const CreateWalletVerifyMnemonicEvent();

  @override
  List<Object> get props => [];
}

class CreateWalletVerifyMnemonicEventStarted extends CreateWalletVerifyMnemonicEvent {}
class CreateWalletVerifyMnemonicEventSaving extends CreateWalletVerifyMnemonicEvent {}
