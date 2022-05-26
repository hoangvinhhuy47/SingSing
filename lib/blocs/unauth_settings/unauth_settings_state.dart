

import 'package:equatable/equatable.dart';
import 'package:sing_app/config/app_localization.dart';

abstract class UnauthSettingsState extends Equatable {
  const UnauthSettingsState();

  @override
  List<Object> get props => [];
}

class UnauthSettingsStateInitial extends UnauthSettingsState {}
class UnauthSettingsStateLoaded extends UnauthSettingsState {}

class OnChangedLanguageState extends UnauthSettingsState {
  final LangCode langCode;
  const OnChangedLanguageState({required this.langCode});

  @override
  List<Object> get props => [langCode];
}