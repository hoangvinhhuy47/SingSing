import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sing_app/constants/enum.dart';
import 'package:sing_app/manager/app_lock_manager.dart';
import 'package:sing_app/utils/logger_util.dart';

import 'local_auth_event.dart';
import 'local_auth_state.dart';

class LocalAuthBloc extends Bloc<LocalAuthEvent, LocalAuthState> {
  String _checkPasscode = '';
  String get checkPasscode => _checkPasscode;

  bool isVerifyPasscode = false;

  bool isWaitingDisableLocalAuthSetting = false;
  bool canBack = false;
  LocalAuthBloc({
      required this.isWaitingDisableLocalAuthSetting, this.canBack = false}) : super(LocalAuthStateInitial()) {
    on<LocalAuthEventStarted>((event, emit) async {
      emit(LocalAuthStateInitial());
      await _mapLocalAuthEventStartedToState(event, emit);
    });

    on<OnTapKeyboardNumberEvent>((event, emit) async {
      emit(CheckingConfirmPasscodeState());
      await _mapCheckLoginOnTapKeyboardNumberEventToState(event, emit);
    });

    on<TapBtnFingerprintEvent>((event, emit) async {
      if (AppLockManager.instance.unlockMethod !=
          UnlockMethod.passcodeAndTouchId) {
        return;
      }
      emit(ShowDialogAuthBiometricState());
    });
  }

  Future<void> _mapLocalAuthEventStartedToState(LocalAuthEventStarted event, Emitter<LocalAuthState> emit) async {
    if (!AppLockManager.instance.enableAppLock || AppLockManager.instance.unlockMethod != UnlockMethod.passcodeAndTouchId) {
      return;
    }
    LoggerUtil.info('_mapLocalAuthEventStartedToState');
    var localAuth = LocalAuthentication();
    AppLockManager.instance.canCheckBiometrics = await localAuth.canCheckBiometrics;
    AppLockManager.instance.availableBiometrics = await localAuth.getAvailableBiometrics();
    LoggerUtil.info(
        'canCheckBiometrics: ${AppLockManager.instance.canCheckBiometrics} - availableBiometrics: ${AppLockManager.instance.availableBiometrics.toString()}');
    emit(CheckingTouchIdState());
  }

  Future<void> _mapCheckLoginOnTapKeyboardNumberEventToState(
      OnTapKeyboardNumberEvent event, Emitter<LocalAuthState> emit) async {
    log('message123123 ${AppLockManager.instance.passcode}');

    if (event.number < 0) {
      if (_checkPasscode.isNotEmpty) {
        _checkPasscode = _checkPasscode.substring(0, _checkPasscode.length - 1);
      }
    } else {
      if (_checkPasscode.length < 6) {
        _checkPasscode += '${event.number}';
      }
    }

    if (_checkPasscode.length == 6) {
      if (AppLockManager.instance.passcode == _checkPasscode) {
        emit(OnLoginSuccessState(passcode: _checkPasscode));
      } else {
        _checkPasscode = '';
        emit(LoginPasscodeFailState());
      }
      return;
    }
    emit(OnPasscodeChangeState(passcode: _checkPasscode));
  }
}
