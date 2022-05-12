import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sing_app/config/app_localization.dart';

@immutable
abstract class ProfileScreenState extends Equatable {
  const ProfileScreenState();

  @override
  List<Object> get props => [];
}

class ProfileScreenStateInitial extends ProfileScreenState {}

class ProfileScreenStateUserInfoFetched extends ProfileScreenState {
  final bool loggedIn;

  const ProfileScreenStateUserInfoFetched({
     required this.loggedIn
  });

  @override
  List<Object> get props => [loggedIn];
}

class ProfileScreenStateLoggingOut extends ProfileScreenState {}
class ProfileScreenStateLoggedOut extends ProfileScreenState {}

class ProfileScreenStateLoading extends ProfileScreenState {
  final bool showLoading;

  const ProfileScreenStateLoading({
    this.showLoading = true
  });

  @override
  List<Object> get props => [showLoading];
}

class ProfileScreenStateUploadAvatar extends ProfileScreenState {
  final File file;

  const ProfileScreenStateUploadAvatar({
    required this.file
  });

  @override
  List<Object> get props => [file];
}

class ProfileScreenStateUploadAvatarError extends ProfileScreenState {}

class ProfileScreenStateUploadCoverError extends ProfileScreenState {
  final String message;
  const ProfileScreenStateUploadCoverError({required this.message});

  @override
  List<Object> get props => [message];
}


class OnChangedLanguageState extends ProfileScreenState {
  final LangCode langCode;
  const OnChangedLanguageState({required this.langCode});

  @override
  List<Object> get props => [langCode];
}

class ChangeUserInfoSuccessfulState extends ProfileScreenState {
  final String email;

  const ChangeUserInfoSuccessfulState({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}