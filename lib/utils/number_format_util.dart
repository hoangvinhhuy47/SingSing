import 'dart:io';

import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart' show numberFormatSymbols;

abstract class NumberFormatUtil {
  static String tokenFormat(num price, {int decimalDigits = 9}) {
    final result = removeTrailingZeros(NumberFormat.currency(locale: getCurrentRegion(), symbol: '', decimalDigits: decimalDigits).format(price));
    return result;
  }

  static String tokenFormatString(String price, {int decimalDigits = 9}) {
    final result = removeTrailingZeros(NumberFormat.currency(locale: getCurrentRegion(), symbol: '', decimalDigits: decimalDigits).format(parse(price)));
    return result;
  }
  static String currencyFormat(num price) {
    return removeTrailingZeros(NumberFormat.currency(locale: getCurrentRegion(), symbol: '', decimalDigits: 4).format(price));
  }
  static String currencyFormatString(String price) {
    return removeTrailingZeros(NumberFormat.currency(locale: getCurrentRegion(), symbol: '', decimalDigits: 4).format(parse(price)));
  }

  static double parse(String? price) {
    if(price == null || price.isEmpty){
      return 0;
    }
    var amount = price.replaceAll(getThousandSeparator(), '');
    amount = amount.replaceAll(getDecimalSeparator(), '.');

    var value = 0.0;
    try{
      value = double.parse(amount);
    } catch(_){}
    return value;
  }

  static String getDecimalSeparator() {
    String locale = getCurrentRegion();
    return numberFormatSymbols[locale]?.DECIMAL_SEP ?? '';
  }

  static String getThousandSeparator() {
    String decimalSep = getDecimalSeparator();
    return decimalSep == '.' ? ',' : '.';
  }

  static String getCurrentRegion() {
    final locale = Platform.localeName;
    if (numberFormatSymbols.keys.contains(locale)) {
      return locale;
    }
    var langCode = locale.split('_')[1];
    if(langCode == 'VN'){
      langCode = 'vi';
    }
    if(langCode.isEmpty || !numberFormatSymbols.keys.contains(langCode)){
      langCode = 'en';
    }
    return langCode;
  }

  static String getCurrentLocale() {
    final locale = Platform.localeName;
    var langCode = locale.split('_')[0];
    if(langCode == 'VN'){
      langCode = 'vi';
    }
    if(langCode.isEmpty){
      langCode = 'en';
    }
    return langCode;
  }

  static String removeTrailingZeros(String price) {
    final regex = RegExp(r"([.]*0+)(?!.*\d)");
    var result = price.replaceAll(regex, '').trim();
    if(result.endsWith(',')){
      result = result.substring(0, result.length - 1);
    }
    return result;
  }
}