import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/unauth_settings/unauth_settings_event.dart';
import 'package:sing_app/blocs/unauth_settings/unauth_settings_state.dart';

class UnauthSettingsBloc extends Bloc<UnauthSettingsEvent, UnauthSettingsState> {

  UnauthSettingsBloc() : super(UnauthSettingsStateInitial()){

    on<UnauthSettingsEventStarted>((event, emit) async {
      await _mapSettingWalletEventStartToState(event, emit);
    });

    on<OnChangedLanguageEvent>((event, emit) async {
      emit(OnChangedLanguageState(langCode: event.langCode));
    });
  }

  Future<void> _mapSettingWalletEventStartToState(UnauthSettingsEventStarted event, Emitter<UnauthSettingsState> emit) async {
    emit(UnauthSettingsStateInitial());


    emit(UnauthSettingsStateLoaded());
  }


}