import 'package:equatable/equatable.dart';

abstract class ChangePasswordState extends Equatable {
  const ChangePasswordState();

  @override
  List<Object> get props => [];
}

class ChangePasswordStateInitial extends ChangePasswordState {}


class ChangePasswordStateLoading extends ChangePasswordState {
  final bool showLoading;

  const ChangePasswordStateLoading({required this.showLoading});

  @override
  List<Object> get props => [showLoading];
}

class ChangePasswordStateSaving extends ChangePasswordState {}
class ChangePasswordStateSaved extends ChangePasswordState {
  final String message;
  const ChangePasswordStateSaved({
    required this.message
  });

  @override
  List<Object> get props => [message];
}

class ChangePasswordStateErrorSaving extends ChangePasswordState {
  final String message;
  const ChangePasswordStateErrorSaving({
    required this.message
  });

  @override
  List<Object> get props => [message];
}