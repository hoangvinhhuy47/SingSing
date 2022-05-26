
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/select_language/select_language_event.dart';
import 'package:sing_app/blocs/select_language/select_language_state.dart';
import 'package:sing_app/blocs/select_token/select_token_event.dart';
import 'package:sing_app/blocs/select_token/select_token_state.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/data/event_bus/event_bus_event.dart';
import 'package:sing_app/data/models/balance.dart';
import 'package:sing_app/utils/storage_utils.dart';

import '../../application.dart';

class SelectLanguageBloc extends Bloc<SelectLanguageEvent, SelectLanguageState> {

  // bool _isSearching = false;
  // bool get isSearching => _isSearching;
  String _currentLanguageCode = defaultLanguageCode;
  String get currentLanguageCode => _currentLanguageCode;

  SelectLanguageBloc() : super(SelectLanguageStateInitial()){
    on<SelectLanguageEventStarted>((event, emit) async {
      _currentLanguageCode = AppLocalization.instance.locale.languageCode;

      emit(SelectLanguageStateInitial());
    });

    on<OnChangeLanguage>((event, emit) async {
      emit(OnChangingLanguageState());
      await AppLocalization.instance.setNewLanguage(langCode: event.langCode);
      _currentLanguageCode = event.langCode.code;
      App.instance.eventBus.fire(EventChangedLanguage(langCode: event.langCode));
      emit(OnChangedLanguageState(langCode: event.langCode));
    });
  }

}