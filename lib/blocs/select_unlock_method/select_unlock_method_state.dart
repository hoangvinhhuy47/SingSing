import 'package:equatable/equatable.dart';
import 'package:sing_app/constants/enum.dart';

abstract class SelectUnlockMethodState extends Equatable {
  const SelectUnlockMethodState();

  @override
  List<Object> get props => [];
}

class SelectUnlockMethodStateInitial extends SelectUnlockMethodState {}


class UnlockMethodChangedState extends SelectUnlockMethodState {
  final UnlockMethod unlockMethod;

  const UnlockMethodChangedState({required this.unlockMethod});

  @override
  List<Object> get props => [unlockMethod];
}
