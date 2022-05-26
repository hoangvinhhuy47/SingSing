import 'package:equatable/equatable.dart';
import 'package:sing_app/constants/enum.dart';

abstract class AddCustomTokenEvent extends Equatable {
  const AddCustomTokenEvent();

  @override
  List<Object> get props => [];
}

class AddCustomTokenEventStart extends AddCustomTokenEvent {}

class PressAddCustomTokenEvent extends AddCustomTokenEvent {
  final String contractAddress;
  final int decimals;

  const PressAddCustomTokenEvent({
    required this.contractAddress,
    required this.decimals,
  });

  @override
  List<Object> get props => [contractAddress, decimals];
}

// class OnChooseNetworkEvent extends AddCustomTokenEvent {
//   final String networkType;
//
//   const OnChooseNetworkEvent({required this.networkType});
//
//   @override
//   List<Object> get props => [networkType];
// }


class OnContractAddressEvent extends AddCustomTokenEvent {
  final String contractAddress;

  const OnContractAddressEvent({required this.contractAddress});

  @override
  List<Object> get props => [contractAddress];
}