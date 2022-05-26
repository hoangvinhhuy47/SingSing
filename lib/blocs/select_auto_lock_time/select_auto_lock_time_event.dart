import 'package:equatable/equatable.dart';
import 'package:sing_app/constants/enum.dart';

abstract class SelectAutoLockTimeEvent extends Equatable {
  const SelectAutoLockTimeEvent();

  @override
  List<Object> get props => [];
}

class SelectAutoLockTimeEventStarted extends SelectAutoLockTimeEvent {}

class AutoLockTimeChangedEvent extends SelectAutoLockTimeEvent {
  final AutoLockDuration autoLockDuration;

  const AutoLockTimeChangedEvent({
    required this.autoLockDuration,
  });

  @override
  List<Object> get props => [autoLockDuration];
}
