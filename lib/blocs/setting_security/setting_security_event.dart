import 'package:equatable/equatable.dart';
import 'package:sing_app/constants/enum.dart';

abstract class SettingSecurityEvent extends Equatable {
  const SettingSecurityEvent();

  @override
  List<Object> get props => [];
}

class SettingSecurityEventStarted extends SettingSecurityEvent {}


class SettingSecurityEventTransactionSigningChanged extends SettingSecurityEvent {
  final bool enable;

  const SettingSecurityEventTransactionSigningChanged({
    required this.enable,
  });

  @override
  List<Object> get props => [enable];
}

class AutoLockDurationChangedEvent extends SettingSecurityEvent {
  final AutoLockDuration autoLockDuration;

  const AutoLockDurationChangedEvent({
    required this.autoLockDuration,
  });

  @override
  List<Object> get props => [autoLockDuration];
}

class UnlockMethodChangedEvent extends SettingSecurityEvent {
  final UnlockMethod unlockMethod;

  const UnlockMethodChangedEvent({
    required this.unlockMethod,
  });

  @override
  List<Object> get props => [unlockMethod];
}