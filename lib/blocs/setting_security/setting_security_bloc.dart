import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/setting_security/setting_security_event.dart';
import 'package:sing_app/blocs/setting_security/setting_security_state.dart';
import 'package:sing_app/constants/enum.dart';
import 'package:sing_app/data/models/admin_keycloark_user_info.dart';
import 'package:sing_app/manager/app_lock_manager.dart';

import '../../application.dart';



class SettingSecurityBloc extends Bloc<SettingSecurityEvent, SettingSecurityState> {
  AdminKeycloarkUserInfo? adminKeycloarkUserInfo;

  SettingSecurityBloc() : super(SettingSecurityStateInitial()) {

    on<SettingSecurityEventStarted>((event, emit) async {
      emit(SettingSecurityStateInitial());
    });
    on<SettingSecurityEventTransactionSigningChanged>((event, emit) async {
      AppLockManager.instance.enableTransactionSigning(event.enable);
      emit(TransactionSigningChangedState(enable: event.enable));
    });

    on<AutoLockDurationChangedEvent>((event, emit) async {
      emit(OnAutoLockDurationChangedState(autoLockDuration: event.autoLockDuration));
    });

    on<UnlockMethodChangedEvent>((event, emit) async {
      emit(OnUnlockMethodChangedState(unlockMethod: event.unlockMethod));
    });


  }

  // Future<void> _mapSettingSecurityEventAppLockChangedToState(SettingSecurityEventAppLockChanged event, Emitter<SettingSecurityState> emit) async {
  //   AppLockManager.instance.enableAppLock = event.enable;
  //   emit(AppLockChangedState(enable: event.enable));
  // }

}
