import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WalletDetailTokenState extends Equatable {
  const WalletDetailTokenState();

  @override
  List<Object> get props => [];
}

class WalletDetailTokenStateLoading extends WalletDetailTokenState {}
class WalletDetailTokenStateLoaded extends WalletDetailTokenState {}
class WalletDetailTokenStatePriceUpdate extends WalletDetailTokenState{}


class ChangeWalletNameSuccessfulState extends WalletDetailTokenState {
  final String wallletId;
  final String name;
  const ChangeWalletNameSuccessfulState(this.wallletId, this.name);
  @override
  List<Object> get props => [wallletId, name];
}