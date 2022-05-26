import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sing_app/blocs/verify_passcode/verify_passcode_event.dart';
import 'package:sing_app/blocs/verify_passcode/verify_passcode_state.dart';
import 'package:sing_app/manager/app_lock_manager.dart';
import 'package:sing_app/utils/logger_util.dart';




class VerifyPasscodeBloc extends Bloc<VerifyPasscodeEvent, VerifyPasscodeState> {

  String _checkPasscode = '';
  String get checkPasscode => _checkPasscode;

  String _verifyPasscode = '';
  String get verifyPasscode => _verifyPasscode;

  bool isVerifyPasscode = false;

  bool isLogin = true;
  bool isDisableBackBtn = false;

  VerifyPasscodeBloc({
    required this.isLogin,
    this.isDisableBackBtn = false
  }) : super(VerifyPasscodeStateInitial()) {

    on<VerifyPasscodeEventStarted>((event, emit) async {
      emit(VerifyPasscodeStateInitial());
    });

    on<OnTapKeyboardNumberEvent>((event, emit) async {
      emit(CheckingConfirmPasscodeState());
      LoggerUtil.info('on<OnTapKeyboardNumberEvent> isLogin: $isLogin');
      if(isLogin) {
        _mapCheckLoginOnTapKeyboardNumberEventToState(event, emit);
        return;
      }
      _mapCheckVerifyPasscodeOnTapKeyboardNumberEventToState(event, emit);

    });


  }

  Future<void> _mapCheckLoginOnTapKeyboardNumberEventToState(OnTapKeyboardNumberEvent event, Emitter<VerifyPasscodeState> emit) async {
    if(event.number < 0) {
      if(_checkPasscode.isNotEmpty) {
        _checkPasscode = _checkPasscode.substring(0, _checkPasscode.length - 1);
      }
    } else {
      if(_checkPasscode.length < 6) {
        _checkPasscode += '${event.number}';
      }
    }

    if(_checkPasscode.length == 6) {
      if(AppLockManager.instance.passcode == _checkPasscode) {
        emit(OnLoginSuccessState(passcode: _checkPasscode));
      } else {
        _checkPasscode = '';
        emit(VerifyPasscodeFailState());
      }
      return;
    }
    emit(OnPasscodeChangeState(passcode: _checkPasscode));
  }

  Future<void> _mapCheckVerifyPasscodeOnTapKeyboardNumberEventToState(OnTapKeyboardNumberEvent event, Emitter<VerifyPasscodeState> emit) async {
    if(event.number < 0) {
      if(isVerifyPasscode) {
        if(_verifyPasscode.isNotEmpty) {
          _verifyPasscode = _verifyPasscode.substring(0, _verifyPasscode.length - 1);
        }
      } else {
        if(_checkPasscode.isNotEmpty) {
          _checkPasscode = _checkPasscode.substring(0, _checkPasscode.length - 1);
        }
      }
    } else {
      if(isVerifyPasscode) {
        if(_verifyPasscode.length < 6) {
          _verifyPasscode += '${event.number}';
        }
      } else {
        if(_checkPasscode.length < 6) {
          _checkPasscode += '${event.number}';
        }
      }
    }
    if(_checkPasscode.length == 6) isVerifyPasscode = true;
    if(_verifyPasscode.length == 6) {
      if(_verifyPasscode == _checkPasscode) {
        AppLockManager.instance.enableSecurity(userPasscode: _checkPasscode);
        emit(VerifyPasscodeSuccessState(passcode: _checkPasscode));
      } else {
        _verifyPasscode = '';
        emit(VerifyPasscodeFailState());
      }
      return;
    }
    emit(OnPasscodeChangeState(passcode: _checkPasscode));
  }

}
