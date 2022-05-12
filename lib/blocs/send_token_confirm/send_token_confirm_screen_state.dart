import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sing_app/data/models/network_gas_fee.dart';

@immutable
abstract class SendTokenConfirmScreenState extends Equatable {
  const SendTokenConfirmScreenState();

  @override
  List<Object> get props => [];
}

class SendTokenConfirmScreenStateInitial extends SendTokenConfirmScreenState {}

class SendTokenConfirmScreenStateNetworkGasFeeCalculated extends SendTokenConfirmScreenState {}

class SendTokenConfirmScreenStateSending extends SendTokenConfirmScreenState {}

class SendTokenConfirmScreenStateSent extends SendTokenConfirmScreenState {}

class SendTokenConfirmScreenStateErrorSending extends SendTokenConfirmScreenState {
  final String message;
  const SendTokenConfirmScreenStateErrorSending({
    required this.message
  });

  @override
  List<Object> get props => [message];
}