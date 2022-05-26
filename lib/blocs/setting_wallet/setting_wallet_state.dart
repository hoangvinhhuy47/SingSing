

import 'package:equatable/equatable.dart';

abstract class SettingWalletState extends Equatable {
  const SettingWalletState();

  @override
  List<Object> get props => [];
}

class SettingWalletStateInitial extends SettingWalletState {}
class SettingWalletStateLoaded extends SettingWalletState {}
class SettingWalletStateWalletDeleting extends SettingWalletState {}
class SettingWalletStateDeleteWalletDone extends SettingWalletState {
  final String message;
  final bool isSuccess;

  const SettingWalletStateDeleteWalletDone({required this.message,required this.isSuccess});

  @override
  List<Object> get props => [message,isSuccess];
}