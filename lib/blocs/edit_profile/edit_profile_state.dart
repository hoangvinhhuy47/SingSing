

import 'package:equatable/equatable.dart';

abstract class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

class EditProfileStateInitial extends EditProfileState {}


class EditProfileStateLoading extends EditProfileState {
  final bool showLoading;

  const EditProfileStateLoading({required this.showLoading});

  @override
  List<Object> get props => [showLoading];
}


class EditProfileStateLoadedUserInfo extends EditProfileState {}

class EditProfileStateLoadedUserInfoError extends EditProfileState {}

class EditProfileStateSaving extends EditProfileState {}
class EditProfileStateSaved extends EditProfileState {}

class EditProfileStateErrorSaving extends EditProfileState {
  final String message;
  const EditProfileStateErrorSaving({
    required this.message
  });

  @override
  List<Object> get props => [message];
}