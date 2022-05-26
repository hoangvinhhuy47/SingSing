import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WalletDetailNftState extends Equatable {
  const WalletDetailNftState();

  @override
  List<Object> get props => [];
}

class WalletDetailNftStateLoading extends WalletDetailNftState {}
class WalletDetailNftStateLoaded extends WalletDetailNftState {
  final String nftId;

  const WalletDetailNftStateLoaded(this.nftId);
  @override
  List<Object> get props => [nftId];

}
class WalletDetailNftStateStatePriceUpdate extends WalletDetailNftState {}


