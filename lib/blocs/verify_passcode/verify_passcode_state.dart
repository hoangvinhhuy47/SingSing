import 'package:equatable/equatable.dart';

abstract class VerifyPasscodeState extends Equatable {
  const VerifyPasscodeState();

  @override
  List<Object> get props => [];
}

class VerifyPasscodeStateInitial extends VerifyPasscodeState {}


class OnPasscodeChangeState extends VerifyPasscodeState {
  final String passcode;

  const OnPasscodeChangeState({required this.passcode});

  @override
  List<Object> get props => [passcode];
}


class VerifyPasscodeSuccessState extends VerifyPasscodeState {
  final String passcode;

  const VerifyPasscodeSuccessState({
    required this.passcode,
  });

  @override
  List<Object> get props => [passcode];
}

class OnLoginSuccessState extends VerifyPasscodeState {
  final String passcode;

  const OnLoginSuccessState({
    required this.passcode,
  });

  @override
  List<Object> get props => [passcode];
}

class CheckingConfirmPasscodeState extends VerifyPasscodeState {}
class VerifyPasscodeFailState extends VerifyPasscodeState {}