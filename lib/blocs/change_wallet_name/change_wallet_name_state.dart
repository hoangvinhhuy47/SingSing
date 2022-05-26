

import 'package:equatable/equatable.dart';

abstract class ChangeWalletNameState extends Equatable {
  const ChangeWalletNameState();

  @override
  List<Object> get props => [];
}

class ChangeWalletNameStateInitial extends ChangeWalletNameState {}
class ChangeWalletNameStateSaving extends ChangeWalletNameState {}
class ChangeWalletNameStateSaved extends ChangeWalletNameState {}
class ChangeWalletNameStateErrorSaving extends ChangeWalletNameState {
  final String message;
  const ChangeWalletNameStateErrorSaving({
    required this.message
  });

  @override
  List<Object> get props => [message];
}