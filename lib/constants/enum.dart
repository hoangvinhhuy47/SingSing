import 'package:sing_app/config/app_localization.dart';

enum AutoLockDuration { immediate, oneMinute, fiveMinute, oneHour, fiveHour }

enum UnlockMethod {passcode, passcodeAndTouchId}

extension AutoLockDurationEx on AutoLockDuration {
  String get title => _getTitle();
  int get seconds => _getSeconds();

  String _getTitle() {
    switch (this) {
      case AutoLockDuration.immediate:
        return l('Immediate');
      case AutoLockDuration.oneMinute:
        return l('If away for 1 minute');
      case AutoLockDuration.fiveMinute:
        return l('If away for 5 minutes');
      case AutoLockDuration.oneHour:
        return l('If away for 1 hour');
      case AutoLockDuration.fiveHour:
        return l('If away for 5 hours');
    }
  }

  int _getSeconds() {
    switch (this) {
      case AutoLockDuration.immediate:
        return 0;
      case AutoLockDuration.oneMinute:
        return 60;
      case AutoLockDuration.fiveMinute:
        return 300;
      case AutoLockDuration.oneHour:
        return 3600;
      case AutoLockDuration.fiveHour:
        return 18000;
    }
  }
}

extension UnlockMethodEx on UnlockMethod {
  String get title => _getTitle();

  String _getTitle() {
    switch (this) {
      case UnlockMethod.passcode:
        return l('Passcode');
      case UnlockMethod.passcodeAndTouchId:
        return l('Passcode/ Biometric');
    }
  }
}