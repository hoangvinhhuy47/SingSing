

import 'package:local_auth/local_auth.dart';
import 'package:sing_app/constants/constants.dart';
import 'package:sing_app/constants/enum.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/storage_utils.dart';

class AppLockManager {
  String tag = 'AppLockManager';

  AppLockManager._privateConstructor();

  static final AppLockManager _instance = AppLockManager._privateConstructor();

  static AppLockManager get instance => _instance;

  // LOCK APP
  bool isLocalAuthSuccess = false;
  bool enableAppLock = false;
  bool isOpenGallery = false;

  AutoLockDuration autoLockDuration = AutoLockDuration.oneMinute;
  bool transactionSigning = false;
  String passcode = '';
  UnlockMethod unlockMethod = UnlockMethod.passcode;

  List<BiometricType> availableBiometrics = [];

  bool canCheckBiometrics = false;

  init() async{
    LoggerUtil.info('init', tag: tag);
    var localAuth = LocalAuthentication();
    canCheckBiometrics = await localAuth.canCheckBiometrics;
    availableBiometrics = await localAuth.getAvailableBiometrics();
    LoggerUtil.info('canCheckBiometrics: $canCheckBiometrics - availableBiometrics: ${availableBiometrics.toString()}', tag: tag);

    enableAppLock = await StorageUtils.getBool(key: storageKeyEnableAppLock, defaultValue: false);
    if(enableAppLock) {
      transactionSigning = await StorageUtils.getBool(key: storageKeyEnableTransactionSigning, defaultValue: false);
      await _loadAutoLockAppDuration();
      passcode = await StorageUtils.getString(key: storageKeyPasscode, defaultValue: '');
      await _loadUnlockMethod();
    }
    LoggerUtil.info('enableAppLock: $enableAppLock');
    LoggerUtil.info('transactionSigning: $transactionSigning');
    LoggerUtil.info('timeLockApp: ${autoLockDuration.seconds}');
    LoggerUtil.info('passcode: $passcode');
    LoggerUtil.info('unlockMethod: ${unlockMethod.title}');
  }

  onAutoLockDurationChanged(AutoLockDuration autoLockDuration) {
    this.autoLockDuration = autoLockDuration;
    StorageUtils.setInt(key: storageKeyAutoLockDuration, value: autoLockDuration.seconds);
  }

  onUnlockMethodChanged(UnlockMethod unlockMethod) {
    this.unlockMethod = unlockMethod;
    StorageUtils.setString(key: storageKeyLockMethod, value: unlockMethod.title);
  }

  enableSecurity({required String userPasscode}) async {
    StorageUtils.setBool(key: storageKeyEnableAppLock, value: true);
    StorageUtils.setBool(key: storageKeyEnableTransactionSigning, value: true);
    StorageUtils.setString(key: storageKeyPasscode, value: userPasscode);

    enableAppLock = true;
    transactionSigning = true;
    passcode = userPasscode;
    await _loadAutoLockAppDuration();
    await _loadUnlockMethod();
  }

  _loadUnlockMethod() async {
    final lockMethod = await StorageUtils.getString(key: storageKeyLockMethod, defaultValue: UnlockMethod.passcode.title);
    if(lockMethod == UnlockMethod.passcodeAndTouchId.title) {
      unlockMethod = UnlockMethod.passcodeAndTouchId;
    }
  }

  _loadAutoLockAppDuration() async {
    int timeLockApp = await StorageUtils.getInt(key: storageKeyAutoLockDuration, defaultValue: 60);
    autoLockDuration = AutoLockDuration.immediate;
    switch(timeLockApp) {
      case 0: autoLockDuration = AutoLockDuration.immediate; break;
      case 60: autoLockDuration = AutoLockDuration.oneMinute; break;
      case 300: autoLockDuration = AutoLockDuration.fiveMinute; break;
      case 3600: autoLockDuration = AutoLockDuration.oneHour; break;
      case 18000: autoLockDuration = AutoLockDuration.fiveHour; break;
    }
  }


  disableSecurity() {
    enableAppLock = false;
    transactionSigning = false;
    passcode = '';
    unlockMethod = UnlockMethod.passcode;

    StorageUtils.setBool(key: storageKeyEnableAppLock, value: false);
    StorageUtils.setBool(key: storageKeyEnableTransactionSigning, value: false);
    StorageUtils.setString(key: storageKeyPasscode, value: '');
    StorageUtils.setString(key: storageKeyLockMethod, value: unlockMethod.title);
  }

  void enableTransactionSigning(bool enable) {
    transactionSigning = enable;
    StorageUtils.setBool(key: storageKeyEnableTransactionSigning, value: enable);
  }
}