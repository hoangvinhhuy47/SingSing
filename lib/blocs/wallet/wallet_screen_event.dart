import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WalletScreenEvent extends Equatable {
  const WalletScreenEvent();

  @override
  List<Object> get props => [];
}
class WalletScreenEventReload extends WalletScreenEvent {}
class WalletScreenEventStarted extends WalletScreenEvent {
  final bool isRefreshing;

  const WalletScreenEventStarted({
    this.isRefreshing = false
  });

  @override
  List<Object> get props => [
    isRefreshing
  ];
}


class WalletScreenShowLoadingEvent extends WalletScreenEvent {
  final bool isLoading;

  const WalletScreenShowLoadingEvent({this.isLoading = false});

  @override
  List<Object> get props => [
    isLoading
  ];
}

class ChangeWalletNameSuccessful extends WalletScreenEvent {
  final String walletId;
  final String name;
  const ChangeWalletNameSuccessful(this.walletId, this.name);
  @override
  List<Object> get props => [walletId, name];
}