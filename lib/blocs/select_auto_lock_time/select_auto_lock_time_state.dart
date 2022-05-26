import 'package:equatable/equatable.dart';
import 'package:sing_app/constants/enum.dart';

abstract class SelectAutoLockTimeState extends Equatable {
  const SelectAutoLockTimeState();

  @override
  List<Object> get props => [];
}

class SelectAutoLockTimeStateInitial extends SelectAutoLockTimeState {}


class AutoLockTimeChangedState extends SelectAutoLockTimeState {
  final AutoLockDuration autoLockDuration;

  const AutoLockTimeChangedState({required this.autoLockDuration});

  @override
  List<Object> get props => [autoLockDuration];
}
