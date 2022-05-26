import 'package:equatable/equatable.dart';

abstract class ChangeEmailEvent extends Equatable {
  const ChangeEmailEvent();

  @override
  List<Object> get props => [];
}

class ChangeEmailStarted extends ChangeEmailEvent {}

class ChangeEmailEventSaving extends ChangeEmailEvent {
  final String newEmail;

  const ChangeEmailEventSaving({
    required this.newEmail,
  });

  @override
  List<Object> get props => [newEmail];
}


