import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WalletDetailState extends Equatable {
  const WalletDetailState();

  @override
  List<Object> get props => [];
}

class WalletDetailStateLoading extends WalletDetailState {}
class WalletDetailStateLoaded extends WalletDetailState {}

class WalletDetailStateShowHideBalance extends WalletDetailState {
  final bool show;
  const WalletDetailStateShowHideBalance(this.show);
  @override
  List<Object> get props => [show];
}

class WalletDetailTabBarChanged extends WalletDetailState {
  final int index;

  const WalletDetailTabBarChanged(this.index);

  @override
  List<Object> get props => [index];
}

class WalletDetailStateTokenPriceUpdate extends WalletDetailState {
  final String symbol;
  const WalletDetailStateTokenPriceUpdate(this.symbol);
  @override
  List<Object> get props => [symbol];
}
