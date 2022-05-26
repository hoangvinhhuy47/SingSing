import 'package:equatable/equatable.dart';

abstract class LocalAuthEvent extends Equatable {
  const LocalAuthEvent();

  @override
  List<Object> get props => [];
}

class LocalAuthEventStarted extends LocalAuthEvent {}

class OnTapKeyboardNumberEvent extends LocalAuthEvent {
  final int number;

  const OnTapKeyboardNumberEvent({
    required this.number,
  });

  @override
  List<Object> get props => [number];
}

class TapBtnFingerprintEvent extends LocalAuthEvent {}

