

import 'package:equatable/equatable.dart';
import 'package:sing_app/config/app_localization.dart';

abstract class UnauthSettingsEvent extends Equatable {
  const UnauthSettingsEvent();

  @override
  List<Object> get props => [];
}

class UnauthSettingsEventStarted extends UnauthSettingsEvent {}

class OnChangedLanguageEvent extends UnauthSettingsEvent {
  final LangCode langCode;
  const OnChangedLanguageEvent({required this.langCode});

  @override
  List<Object> get props => [langCode];
}