

import 'package:equatable/equatable.dart';

abstract class SettingWalletState extends Equatable {
  const SettingWalletState();

  @override
  List<Object> get props => [];
}

class SettingWalletStateInitial extends SettingWalletState {}
class SettingWalletStateLoaded extends SettingWalletState {}