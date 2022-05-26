import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sing_app/utils/color_util.dart';
import 'package:sing_app/utils/theme_util.dart';

class MyStyles {
  late ThemeData themeData;

  MyStyles(this.themeData);

  factory MyStyles.of(BuildContext context) {
    return MyStyles(Theme.of(context));
  }

  TextStyle tooltipText() => GoogleFonts.ibmPlexSans(
          textStyle: const TextStyle(
        color: ColorUtil.lightGrey,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ));

  TextStyle secondaryText() => GoogleFonts.ibmPlexSans(
          textStyle: const TextStyle(
        color: ColorUtil.grey300,
        fontSize: 14,
        fontWeight: MyFontWeight.regular,
      ));

  TextStyle hintText() => GoogleFonts.ibmPlexSans(
          textStyle: const TextStyle(
        color: ColorUtil.formHintText,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ));

  TextStyle valueText() => GoogleFonts.ibmPlexSans(
          textStyle: const TextStyle(
        color: Colors.white,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ));

  TextStyle buttonTextStyle() => GoogleFonts.ibmPlexSans(
      textStyle: const TextStyle(
          color: ColorUtil.white, fontSize: 16, fontWeight: FontWeight.w500));

  TextStyle settingWalletTextStyle() => GoogleFonts.ibmPlexSans(
      textStyle: const TextStyle(
          color: Color(0xFFB1BBD2), fontSize: 12, fontWeight: FontWeight.w500));

  TextStyle screenTitleText() => GoogleFonts.ibmPlexSans(
          textStyle: const TextStyle(
        color: ColorUtil.white,
        fontSize: 24,
        fontWeight: MyFontWeight.medium,
      ));

  static const horizontalMargin = 16.0;
  static const verticalMargin = 18.0;
}

TextStyle s(BuildContext context,
    {double? fontSize,
    Color? color,
    FontWeight? fontWeight = MyFontWeight.regular,
    double? height,
    String? fontFamily}) {
  return MyStyles.of(context).valueText().copyWith(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        height: height,
        fontFamily: fontFamily,
      );
}
