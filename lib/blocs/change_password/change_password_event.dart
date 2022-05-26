import 'package:equatable/equatable.dart';

abstract class ChangePasswordEvent extends Equatable {
  const ChangePasswordEvent();

  @override
  List<Object> get props => [];
}

class ChangePasswordStarted extends ChangePasswordEvent {}

class ChangePasswordEventSaving extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;

  const ChangePasswordEventSaving({
    required this.oldPassword,
    required this.newPassword
  });

  @override
  List<Object> get props => [newPassword, oldPassword];
}


