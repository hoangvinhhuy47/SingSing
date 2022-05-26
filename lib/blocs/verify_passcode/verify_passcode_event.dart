import 'package:equatable/equatable.dart';

abstract class VerifyPasscodeEvent extends Equatable {
  const VerifyPasscodeEvent();

  @override
  List<Object> get props => [];
}

class VerifyPasscodeEventStarted extends VerifyPasscodeEvent {}

class OnTapKeyboardNumberEvent extends VerifyPasscodeEvent {
  final int number;

  const OnTapKeyboardNumberEvent({
    required this.number,
  });

  @override
  List<Object> get props => [number];
}


