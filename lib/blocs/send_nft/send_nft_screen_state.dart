import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class SendNftScreenState extends Equatable {
  const SendNftScreenState();

  @override
  List<Object> get props => [];
}

class SendNftScreenStateInitial extends SendNftScreenState {}

class SendNftScreenStateSending extends SendNftScreenState {}

class SendNftScreenStateSent extends SendNftScreenState {}

class SendNftScreenStateErrorSending extends SendNftScreenState {
  final String message;
  const SendNftScreenStateErrorSending({
    required this.message
  });

  @override
  List<Object> get props => [message];
}