import 'package:equatable/equatable.dart';
import 'package:sing_app/data/models/balance.dart';

abstract class SettingWalletEvent extends Equatable {
  const SettingWalletEvent();

  @override
  List<Object> get props => [];
}

class SettingWalletEventStart extends SettingWalletEvent {}
class SettingWalletEventReload extends SettingWalletEvent {}

class OnWalletDeletingEvent extends SettingWalletEvent {}

class OnTextSearchChangedEvent extends SettingWalletEvent {
  final String text;
  const OnTextSearchChangedEvent({required this.text});

  @override
  List<Object> get props => [text];
}

class OnBalanceCheckedChangeEvent extends SettingWalletEvent {
  final bool isChecked;
  final Balance balance;

  const OnBalanceCheckedChangeEvent({
    required this.isChecked,
    required this.balance,
  });

  @override
  List<Object> get props => [isChecked, balance];
}

