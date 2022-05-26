import 'package:equatable/equatable.dart';

abstract class LocalAuthState extends Equatable {
  const LocalAuthState();

  @override
  List<Object> get props => [];
}

class LocalAuthStateInitial extends LocalAuthState {}


class OnPasscodeChangeState extends LocalAuthState {
  final String passcode;

  const OnPasscodeChangeState({required this.passcode});

  @override
  List<Object> get props => [passcode];
}


// class LoginPasscodeSuccessState extends LocalAuthState {
//   final String passcode;
//
//   const LoginPasscodeSuccessState({
//     required this.passcode,
//   });
//
//   @override
//   List<Object> get props => [passcode];
// }

class OnLoginSuccessState extends LocalAuthState {
  final String passcode;

  const OnLoginSuccessState({
    required this.passcode,
  });

  @override
  List<Object> get props => [passcode];
}

class CheckingConfirmPasscodeState extends LocalAuthState {}
class LoginPasscodeFailState extends LocalAuthState {}

class CheckingTouchIdState extends LocalAuthState {}

class ShowDialogAuthBiometricState extends LocalAuthState {}
