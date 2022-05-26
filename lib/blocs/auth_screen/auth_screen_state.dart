
import 'package:equatable/equatable.dart';

import '../../data/models/user_profile.dart';

abstract class AuthScreenState extends Equatable {
  const AuthScreenState();

  @override
  List<Object> get props => [];
}

class AuthScreenStateInitial extends AuthScreenState{}

class AuthScreenStateCheckInternet extends AuthScreenState{}
class AuthScreenStateNoInternet extends AuthScreenState{}

class AuthScreenLoadingState extends AuthScreenState{
  final bool isLoading;

  const AuthScreenLoadingState({required this.isLoading});

  @override
  List<Object> get props => [isLoading];
}

class AuthScreenSuccessState extends AuthScreenState{}

class AuthScreenGetUserProfileSuccess extends AuthScreenState {
  final UserProfile userProfile;

  const AuthScreenGetUserProfileSuccess({
    required this.userProfile,
  });

  @override
  List<Object> get props => [userProfile];
}