import 'package:equatable/equatable.dart';
import 'package:sing_app/constants/enum.dart';

abstract class AddCustomTokenState extends Equatable {
  const AddCustomTokenState();

  @override
  List<Object> get props => [];
}

class AddCustomTokenStateInitial extends AddCustomTokenState {}

class AddCustomTokenLoadingState extends AddCustomTokenState {}

class AddCustomTokenLoadedState extends AddCustomTokenState {}

// class OnChooseNetworkState extends AddCustomTokenState {
//   final NetworkType networkType;
//
//   const OnChooseNetworkState({required this.networkType});
//
//   @override
//   List<Object> get props => [networkType];
// }

class OnContractAddressChangedState extends AddCustomTokenState {
  final String contractAddress;

  const OnContractAddressChangedState({required this.contractAddress});

  @override
  List<Object> get props => [contractAddress];
}

class GetContractInfoSuccessState extends AddCustomTokenState {}
class GetContractInfoErrorState extends AddCustomTokenState {
  final String error;

  const GetContractInfoErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}

class AddCustomTokenSuccessState extends AddCustomTokenState {}

class AddCustomTokenErrorState extends AddCustomTokenState {
  final String error;

  const AddCustomTokenErrorState({
    required this.error,
  });

  @override
  List<Object> get props => [error];
}