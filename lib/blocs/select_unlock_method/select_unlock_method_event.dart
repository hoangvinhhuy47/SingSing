import 'package:equatable/equatable.dart';
import 'package:sing_app/constants/enum.dart';

abstract class SelectUnlockMethodEvent extends Equatable {
  const SelectUnlockMethodEvent();

  @override
  List<Object> get props => [];
}

class SelectUnlockMethodEventStarted extends SelectUnlockMethodEvent {}

class UnlockMethodChangedEvent extends SelectUnlockMethodEvent {
  final UnlockMethod unlockMethod;

  const UnlockMethodChangedEvent({
    required this.unlockMethod,
  });

  @override
  List<Object> get props => [unlockMethod];
}
