import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sing_app/config/app_config.dart';
import 'package:sing_app/config/app_localization.dart';
import 'package:sing_app/constants/localization_key.dart';
import 'package:sing_app/utils/styles.dart';

import 'color_util.dart';

showSnackBar(BuildContext context,
    {required String message,
    Color? color,
    Duration? duration,
    TextStyle? style}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: style),
      backgroundColor: color,
      duration: duration ?? const Duration(seconds: 4),
    ),
  );
}

showSnackBarError({
  required BuildContext context,
  required String message,
  Duration? duration,
}) {
  // if (AppConfig.isProduction()) {
  //   showSnackBar(context,
  //       message: l(LocalizationKey.errorGeneral),
  //       color: ColorUtil.orangePink,
  //       duration: duration,
  //       style: s(context, color: Colors.white));
  //   return;
  // }
  showSnackBar(
    context,
    message: message,
    color: ColorUtil.orangePink,
    duration: duration,
    style: s(context, color: Colors.white),
  );
}

showSnackBarSuccess({
  required BuildContext context,
  required String message,
  Duration? duration,
}) {
  showSnackBar(
    context,
    message: message,
    color: ColorUtil.emerald,
    duration: duration,
    style: s(context, color: Colors.black),
  );
}
