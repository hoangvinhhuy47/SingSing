import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:sing_app/utils/logger_util.dart';
import 'package:sing_app/utils/number_format_util.dart';
import 'package:sing_app/utils/storage_utils.dart';

const String languageKey = 'language';
String defaultLanguageCode = LangCode.vi.code;

final List<String> _supportedLanguages = [
  LangCode.vi.code,
  LangCode.en.code,
];

class AppLocalization {
  /// ----------------------------------------------------------
  /// SINGLETON
  /// ----------------------------------------------------------
  AppLocalization._privateConstructor();

  static final AppLocalization instance = AppLocalization._privateConstructor();

  /// Variables
  Locale _locale = const Locale('vi', 'VN');
  LangCode _currentLangCode = LangCode.vi;
  Map<String, dynamic>? _localizedStrings;
  VoidCallback? onLocaleChangedCallback;

  /// Returns the current language code
  LangCode get currentLangCode => _currentLangCode;

  /// Returns the current Locale
  Locale get locale => _locale;

  /// return the current currency symbol
  String get currentCurrencySymbol =>
      NumberFormat.simpleCurrency(locale: _locale.toString()).currencySymbol;

  /// return the VND currency symbol
  String get vndSymbol => NumberFormat.simpleCurrency(locale: LangCode.vi.code).currencySymbol;

  /// Return a list of supported language
  Iterable<Locale> supportedLocales() =>
      _supportedLanguages.map<Locale>((lang) => Locale(lang, ''));

  /// Returns the translation that corresponds to the [key]
  String text(String key) {
    return (_localizedStrings == null || _localizedStrings?[key] == null)
        ? key
        : _localizedStrings?[key];
  }

  /// One-time initialization
  Future init([LangCode? langCode]) async {
    if (langCode != null) {
      await setNewLanguage(
        langCode: langCode,
      );
    } else {
      LangCode? langCode;
      final String currentCode = await StorageUtils.getString(key: languageKey, defaultValue: '');
      /// get user lang
      if(currentCode.isNotEmpty){
        for (final LangCode code in LangCode.values) {
          if (code.code == currentCode) {
            langCode = code;
            break;
          }
        }
      }

      if(langCode == null){
        //get system lang
        final lang = NumberFormatUtil.getCurrentLocale().toLowerCase();
        if(lang == 'vi' || lang == 'vn'){
          langCode = LangCode.vi;
        } else {
          langCode = LangCode.en;
        }
      }
      await setNewLanguage(
        langCode: langCode,
        saveInPrefs: false,
      );
    }
    return null;
  }

  /// Change the language
  Future setNewLanguage({
    LangCode langCode = LangCode.vi,
    bool saveInPrefs = true,
  }) async {
    _currentLangCode = langCode;
    _locale = Locale(langCode.code, '');

    final String jsonContent = await rootBundle.loadString('lang/${_locale.languageCode}.json');
    _localizedStrings = json.decode(jsonContent);

    if (saveInPrefs) {
      await StorageUtils.setString(key: languageKey, value: langCode.code);
    }
    onLocaleChangedCallback?.call();
    return null;
  }

}

// Instantiate the singleton

String l(String key) {
  return AppLocalization.instance.text(key);
}

enum LangCode {
  vi,
  en,
}

extension LanguageExtension on LangCode {
  String get code {
    switch (this) {
      case LangCode.vi:
        return 'vi';
      case LangCode.en:
        return 'en';
    }
    return '';
  }

  String get currencyCode {
    switch (this) {
      case LangCode.vi:
        return 'VND';
      case LangCode.en:
        return 'USD';
    }
    return '';
  }

  String get getCurrencyUnit {
    switch (this) {
      case LangCode.vi:
        return 'đ';
      case LangCode.en:
        return '\$';
    }
    return '';
  }
}
