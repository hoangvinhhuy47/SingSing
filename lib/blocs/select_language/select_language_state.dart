

import 'package:equatable/equatable.dart';
import 'package:sing_app/config/app_localization.dart';

abstract class SelectLanguageState extends Equatable {
  const SelectLanguageState();

  @override
  List<Object> get props => [];
}

class SelectLanguageStateInitial extends SelectLanguageState {}

class OnChangingLanguageState extends SelectLanguageState {}

class OnChangedLanguageState extends SelectLanguageState {
  final LangCode langCode;
  const OnChangedLanguageState({required this.langCode});

  @override
  List<Object> get props => [langCode];
}