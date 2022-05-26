import 'package:equatable/equatable.dart';

abstract class ImportWalletState extends Equatable {
  const ImportWalletState();

  @override
  List<Object> get props => [];
}

class ImportWalletStateInitial extends ImportWalletState {}
class ImportWalletStateStarted extends ImportWalletState {}
class ImportWalletStateSaving extends ImportWalletState {}
class ImportWalletStateSaved extends ImportWalletState {}
class ImportWalletStateErrorSaving extends ImportWalletState {
  final String message;
  const ImportWalletStateErrorSaving({
    required this.message
  });

  @override
  List<Object> get props => [message];
}

class ImportWalletStateTabBarChanged extends ImportWalletState {
  final int index;

  const ImportWalletStateTabBarChanged(this.index);

  @override
  List<Object> get props => [index];
}