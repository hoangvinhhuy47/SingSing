import 'package:equatable/equatable.dart';
import 'package:sing_app/constants/enum.dart';

abstract class SettingSecurityState extends Equatable {
  const SettingSecurityState();

  @override
  List<Object> get props => [];
}

class SettingSecurityStateInitial extends SettingSecurityState {}


class TransactionSigningChangedState extends SettingSecurityState {
  final bool enable;

  const TransactionSigningChangedState({required this.enable});

  @override
  List<Object> get props => [enable];
}

class OnAutoLockDurationChangedState extends SettingSecurityState {
  final AutoLockDuration autoLockDuration;

  const OnAutoLockDurationChangedState({required this.autoLockDuration});

  @override
  List<Object> get props => [autoLockDuration];
}

class OnUnlockMethodChangedState extends SettingSecurityState {
  final UnlockMethod unlockMethod;

  const OnUnlockMethodChangedState({required this.unlockMethod});

  @override
  List<Object> get props => [unlockMethod];
}