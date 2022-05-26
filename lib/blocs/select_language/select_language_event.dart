import 'package:equatable/equatable.dart';
import 'package:sing_app/config/app_localization.dart';

abstract class SelectLanguageEvent extends Equatable {
  const SelectLanguageEvent();

  @override
  List<Object> get props => [];
}

class SelectLanguageEventStarted extends SelectLanguageEvent {}

class OnChangeLanguage extends SelectLanguageEvent {
  final LangCode langCode;
  const OnChangeLanguage({required this.langCode});

  @override
  List<Object> get props => [langCode];
}


