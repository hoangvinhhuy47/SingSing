import 'package:equatable/equatable.dart';
import '../../oauth2/oauth2_token.dart';

abstract class AuthScreenEvent extends Equatable{
  const AuthScreenEvent();

  @override
  List<Object> get props => [];
}

// class AuthScreenStarted extends AuthScreenEvent {}

class AuthScreenCheckInternet extends AuthScreenEvent {}

class AuthScreenLoggedIn extends AuthScreenEvent {
  final Oauth2Token token;

  const AuthScreenLoggedIn({
    required this.token,
  });

  @override
  List<Object> get props => [token];
}