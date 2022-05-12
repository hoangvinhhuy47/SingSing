import 'package:flutter/material.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/theme_util.dart';

class MyStyles {
  late ThemeData themeData;

  MyStyles(this.themeData);

  factory MyStyles.of(BuildContext context) {
    return MyStyles(Theme.of(context));
  }

  TextStyle tooltipText() => const TextStyle(
    color: ColorUtil.lightGrey,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  TextStyle valueText() => const TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  TextStyle buttonTextStyle() => const TextStyle(
      color: ColorUtil.white,
      fontSize: 16,
      fontWeight: FontWeight.w500
  );

  TextStyle settingWalletTextStyle() => const TextStyle(
      color: Color(0xFFB1BBD2),
      fontSize: 12,
      fontWeight: FontWeight.w500
  );

  static const horizontalMargin = 16.0;
}


TextStyle s(BuildContext context, {double? fontSize, Color? color, FontWeight? fontWeight, double? height}) {
  return MyStyles.of(context).valueText().copyWith(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    height: height,
  );
}