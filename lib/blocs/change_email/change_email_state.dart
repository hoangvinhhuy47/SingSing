import 'package:equatable/equatable.dart';

abstract class ChangeEmailState extends Equatable {
  const ChangeEmailState();

  @override
  List<Object> get props => [];
}

class ChangeEmailStateInitial extends ChangeEmailState {}


class ChangeEmailStateLoading extends ChangeEmailState {
  final bool showLoading;

  const ChangeEmailStateLoading({required this.showLoading});

  @override
  List<Object> get props => [showLoading];
}


class ChangeEmailStateSaved extends ChangeEmailState {
  final String message;
  const ChangeEmailStateSaved({
    required this.message
  });

  @override
  List<Object> get props => [message];
}

class ChangeEmailStateErrorSaving extends ChangeEmailState {
  final String message;
  const ChangeEmailStateErrorSaving({
    required this.message
  });

  @override
  List<Object> get props => [message];
}