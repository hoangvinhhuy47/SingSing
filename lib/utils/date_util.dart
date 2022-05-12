import 'package:intl/intl.dart';

const String defaultFormat = 'dd/MM/yyyy - hh:mm a';

const String covalentDefaultFormat = 'yyyy-MM-ddThh:mm:ssZ';

extension IntExtension on int {
  String toDateString({String format = defaultFormat}) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(this * 1000);
    final DateFormat formatter = DateFormat(format);
    return formatter.format(date);
  }

  String toMillisecondDateString({String format = defaultFormat}) {
    final DateTime date = DateTime.fromMillisecondsSinceEpoch(this);
    final DateFormat formatter = DateFormat(format);
    return formatter.format(date);
  }
}

extension DateExtension on DateTime {
  String toDateString({String format = defaultFormat}) {
    final DateFormat formatter = DateFormat(format);
    return formatter.format(this);
  }
}


extension StringDateExtension on String {

  String convertCovalentDateToString({required String format}) {
    var dateTime = DateFormat(covalentDefaultFormat).parse(this);
    return dateTime.toDateString(format: format);
  }

  String convertToDateString({required String fromFormat, required String toFormat}) {
    var dateTime = DateFormat(fromFormat).parse(this);
    return dateTime.toDateString(format: toFormat);
  }
}
