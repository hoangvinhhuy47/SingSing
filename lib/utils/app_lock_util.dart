import 'package:flutter/cupertino.dart';
import 'package:sing_app/constants/extension_constant.dart';
import 'package:sing_app/utils/logger_util.dart';

import '../constants/constants.dart';
import '../manager/app_lock_manager.dart';
import '../routes.dart';

class AppLockUtil {
  static Future checkPassCode({
    required BuildContext context,
    bool? condition,
    required void Function() function,
  }) async {
    if (condition ?? AppLockManager.instance.enableAppLock) {
      await Navigator.pushNamed(context, Routes.localAuthScreen,
          arguments: {LocalAuthScreenArgs.canBack: true}).then((value) {
        LoggerUtil.printLog(message: 'Value123123 $value');
        final arguments = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>;
        final result =
            arguments[LocalAuthScreenSettingArgs.isPasscodeCorrect.value];
        LoggerUtil.printLog(message: 'checkPassCode result $result');
        if (result) {
          function();
        }
      });
    } else {
      function();
    }
  }
}
