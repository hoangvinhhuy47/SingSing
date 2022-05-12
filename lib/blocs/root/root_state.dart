import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RootState extends Equatable {
  const RootState();

  @override
  List<Object> get props => [];
}

class Uninitialized extends RootState {}

class Unauthenticated extends RootState {}

class OpenIntroScreen extends RootState {}

class LoggedOutSuccess extends RootState {}

class LoggedInSuccess extends RootState {}
class GetUserProfileSuccess extends RootState {}

class UnauthenticatedWithStoredCredential extends RootState {}

class Authenticated extends RootState {}

class NoInternetConnection extends RootState {}

class ShowLoginPopup extends RootState {}
class ShowRegistrationsPopup extends RootState {}
class HideOath2Popup extends RootState {}

class ShowAccessTokenExpiredAlert extends RootState {}

class NewVersionAvailable extends RootState {
  final String version;

  const NewVersionAvailable(this.version);

  @override
  List<Object> get props => [version];
}