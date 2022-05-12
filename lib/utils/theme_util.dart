import 'package:flutter/material.dart';
import 'package:sing_app/utils/color_util.dart';

class ThemeUtil {

  static ThemeData appTheme = ThemeData(

    // Define the default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: ColorUtil.primary,
    hintColor: ColorUtil.blueGrey,
    // backgroundColor: ColorUtil.paleGreyTwo,
    scaffoldBackgroundColor: ColorUtil.primary,



    // Define the default TextTheme. Use this to specify the default
    // text styling for headlines, titles, bodies of text, and more.
    textTheme: const TextTheme(

      headline5: TextStyle(color: ColorUtil.defaultTextColor, fontSize: 17, fontWeight: MyFontWeight.semiBold),

      //Large text in app bar title
      headline6: TextStyle(color: ColorUtil.defaultTextColor, fontSize: 16, fontWeight: MyFontWeight.semiBold),

      //Primary text in list title
      subtitle1: TextStyle(color: ColorUtil.defaultTextColor, fontSize: 15, fontWeight: MyFontWeight.regular),

      //Used for emphasizing text in body
      bodyText1: TextStyle(color: ColorUtil.defaultTextColor, fontSize: 15, fontWeight: MyFontWeight.regular),

      //Default Textstyle
      bodyText2: TextStyle(color: ColorUtil.defaultTextColor, fontSize: 14, fontWeight: MyFontWeight.regular),

      //Default button textstyle
      button: TextStyle(color: ColorUtil.defaultTextColor, fontSize: 16, fontWeight: MyFontWeight.semiBold),


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
