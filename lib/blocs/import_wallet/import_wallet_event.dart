import 'package:equatable/equatable.dart';

abstract class ImportWalletEvent extends Equatable {
  const ImportWalletEvent();

  @override
  List<Object> get props => [];
}

class ImportWalletEventStarted extends ImportWalletEvent {}
class ImportWalletEventSaving extends ImportWalletEvent {
  final String name;
  final String data;
  const ImportWalletEventSaving(this.name, this.data);

  @override
  List<Object> get props => [name, data];
}


class ImportWalletEventTabBarPressed extends ImportWalletEvent {
  final int index;

  const ImportWalletEventTabBarPressed(this.index);

  @override
  List<Object> get props => [index];
}

