import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:sing_app/oauth2/oauth2_token.dart';

import '../../data/models/user_profile.dart';

@immutable
abstract class RootEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AppStarted extends RootEvent {}

class LoggedIn extends RootEvent {
  final Oauth2Token token;

  LoggedIn({
    required this.token
  }) : super();
}
class LoggedOut extends RootEvent {}

class NoInternet extends RootEvent {}

class HideIntroScreen extends RootEvent {}

class UpdateButtonPressed extends RootEvent {}

class AccessTokenExpired extends RootEvent {}

class ShowLoginPopupEvent extends RootEvent {}
class HideLoginPopupEvent extends RootEvent {}

class ShowRegistrationPopupEvent extends RootEvent {}
class HideRegistrationPopupEvent extends RootEvent {}

class DismissAccessTokenExpiredAlert extends RootEvent {}

class AutoLockAppEvent extends RootEvent {
  final int timeStamp;

  AutoLockAppEvent({
    required this.timeStamp,
  });

  @override
  List<Object> get props => [timeStamp];
}

class LocalAuthSuccess extends RootEvent {}

class GetUserProfileSuccessEvent extends RootEvent {
  final UserProfile userProfile;

  GetUserProfileSuccessEvent({
    required this.userProfile,
  });

  @override
  List<Object> get props => [userProfile];
}

