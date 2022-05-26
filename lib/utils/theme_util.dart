import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sing_app/utils/color_util.dart';

class ThemeUtil {

  static ThemeData appTheme = ThemeData(

    // Define the default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: ColorUtil.primary,
    hintColor: ColorUtil.blueGrey,
    // backgroundColor: ColorUtil.paleGreyTwo,
    scaffoldBackgroundColor: ColorUtil.backgroundPrimary,



    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: TextTheme(
      headline5: GoogleFonts.ibmPlexSans(
          textStyle: const TextStyle(
              color: ColorUtil.defaultTextColor,
              fontSize: 17,
              fontWeight: MyFontWeight.semiBold)),

      //Large text in app bar title
      headline6: GoogleFonts.ibmPlexSans(
          textStyle: const TextStyle(
              color: ColorUtil.defaultTextColor,
              fontSize: 16,
              fontWeight: MyFontWeight.semiBold)),

      //Primary text in list title
      subtitle1: GoogleFonts.ibmPlexSans(
          textStyle: const TextStyle(
              color: ColorUtil.defaultTextColor,
              fontSize: 15,
              fontWeight: MyFontWeight.regular)),

      //Used for emphasizing text in body
      bodyText1: GoogleFonts.ibmPlexSans(
          textStyle: const TextStyle(
              color: ColorUtil.defaultTextColor,
              fontSize: 15,
              fontWeight: MyFontWeight.regular)),

      //Default Textstyle
      bodyText2: GoogleFonts.ibmPlexSans(
          textStyle: const TextStyle(
              color: ColorUtil.defaultTextColor,
              fontSize: 14,
              fontWeight: MyFontWeight.regular)),

      //Default button textstyle
      button: GoogleFonts.ibmPlexSans(
          textStyle: const TextStyle(
              color: ColorUtil.defaultTextColor,
              fontSize: 16,
              fontWeight: MyFontWeight.semiBold)),
    ).apply(
      bodyColor: ColorUtil.defaultTextColor,
      displayColor: ColorUtil.defaultTextColor,
    ),
    // fontFamily: 'Montserrat', colorScheme: ColorScheme.fromSwatch().copyWith(secondary: ColorUtil.mustardAccent),
  );
}

class MyFontWeight {

  static const thin = FontWeight.w100;
  static const extraLight = FontWeight.w200;
  static const light = FontWeight.w300;
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semiBold = FontWeight.w600;
  static const bold = FontWeight.w700;
  static const extraBold = FontWeight.w800;
  static const ultraBold = FontWeight.w900;

}
