import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WalletDetailEvent extends Equatable {
  const WalletDetailEvent();

  @override
  List<Object> get props => [];
}

class WalletDetailEventStart extends WalletDetailEvent {}
class WalletDetailEventReload extends WalletDetailEvent {}

class WalletDetailEventShowHideBalance extends WalletDetailEvent {
  final bool show;
  const WalletDetailEventShowHideBalance(this.show);
  @override
  List<Object> get props => [show];
}

class WalletDetailTabBarPressedEvent extends WalletDetailEvent {
  final int index;

  const WalletDetailTabBarPressedEvent(this.index);

  @override
  List<Object> get props => [index];
}
