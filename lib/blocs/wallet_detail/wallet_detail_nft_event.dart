import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WalletDetailNftEvent extends Equatable {
  const WalletDetailNftEvent();

  @override
  List<Object> get props => [];
}

class WalletDetailNftEventStart extends WalletDetailNftEvent {}
class WalletDetailNftEventReload extends WalletDetailNftEvent {}
class WalletDetailNftEventTokenPriceUpdate extends WalletDetailNftEvent {}