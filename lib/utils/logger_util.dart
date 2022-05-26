import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sing_app/config/app_config.dart';


class ANSI {
  static const String reset =  '\x1B[0m';
  static const String black =  '\x1B[30m';
  static const String white =  '\x1B[37m';
  static const String red =  '\x1B[31m';
  static const String green =  '\x1B[32m';
  static const String yellow =  '\x1B[33m';
  static const String blue =  '\x1B[34m';
  static const String cyan =  '\x1B[36m';
  static const String greyBg =  '\x1B[100m';
}

class LoggerUtil {
  static Logger? _logger;
  static void printLog({required String message, String? tag, StackTrace? stackTrace}) {
    if(AppConfig.instance.values.enableLog) {
      // logger ??= Logger();
      // logger?.log(level, message);
      String time = '(${DateFormat('HH:mm:ss').format(DateTime.now())})';
      // print('''\u001b[31m$message\u001b[0m''');
      log('$time - $message', name: tag ?? 'log', stackTrace: stackTrace);
      // print('($time) ${ANSI.green}[$tag]${ANSI.reset} $message');
      // print('($time) ${ANSI.green}[$tag]${ANSI.reset} $message');
    }
  }

  static void error(String message) {
    printLog(message: message, tag: 'error');
  }

  static void trace(String message, StackTrace? stackTrace) {
    printLog(message: message, tag: 'error', stackTrace: stackTrace);
  }

  static void warning(String message) {
    printLog(message: message, tag: 'warning');
  }

  static void info(String message, {String? tag}) {
    printLog(message: message, tag: tag ?? 'info');
    // printLog(message: '${ANSI.blue}$message${ANSI.reset}', tag: tag ?? 'info');
  }

  static void debug(String message, {String? tag}) {
    printLog(message: message, tag: tag ?? 'debug');
  }
}