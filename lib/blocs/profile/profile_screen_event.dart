import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sing_app/config/app_localization.dart';

@immutable
abstract class ProfileScreenEvent extends Equatable {
  const ProfileScreenEvent();

  @override
  List<Object> get props => [];
}

class ProfileScreenEventStarted extends ProfileScreenEvent {
  final bool isRefreshing;//refresh after logged in

  const ProfileScreenEventStarted({
    this.isRefreshing = false
  });

  @override
  List<Object> get props => [
    isRefreshing
  ];
}


class ProfileScreenShowLoadingEvent extends ProfileScreenEvent {
  final bool isLoading;//refresh after logged in

  const ProfileScreenShowLoadingEvent({
    this.isLoading = false
  });

  @override
  List<Object> get props => [
    isLoading
  ];
}

class ProfileScreenEventLogout extends ProfileScreenEvent {

}

class ProfileScreenEventReload extends ProfileScreenEvent {

}

class ProfileScreenEventUploadAvatar extends ProfileScreenEvent {
  final File file;
  final String mimeType;

  const ProfileScreenEventUploadAvatar({
    required this.file,
    required this.mimeType
  });

  @override
  List<Object> get props => [file, mimeType];
}

class ProfileScreenEventUploadCover extends ProfileScreenEvent {
  final File file;
  final String mimeType;

  const ProfileScreenEventUploadCover({
    required this.file,
    required this.mimeType
  });

  @override
  List<Object> get props => [file, mimeType];
}

class OnChangeLanguageProfileScreenEvent extends ProfileScreenEvent {
  final LangCode langCode;
  const OnChangeLanguageProfileScreenEvent({required this.langCode});

  @override
  List<Object> get props => [langCode];
}

class ChangeUserInfoSuccessfulEvent extends ProfileScreenEvent {
  final String email;

  const ChangeUserInfoSuccessfulEvent({
    required this.email,
  });

  @override
  List<Object> get props => [email];
}