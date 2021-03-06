import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WalletDetailTokenEvent extends Equatable {
  const WalletDetailTokenEvent();

  @override
  List<Object> get props => [];
}

class WalletDetailTokenEventStart extends WalletDetailTokenEvent {}
class WalletDetailTokenEventReload extends WalletDetailTokenEvent {}

class WalletDetailTokenPriceUpdate extends WalletDetailTokenEvent {
  final String symbol;
  const WalletDetailTokenPriceUpdate(this.symbol);
  @override
  List<Object> get props => [symbol];
}


class ChangeWalletNameSuccessful extends WalletDetailTokenEvent {
  final String wallletId;
  final String name;
  const ChangeWalletNameSuccessful(this.wallletId, this.name);
  @override
  List<Object> get props => [wallletId, name];
}