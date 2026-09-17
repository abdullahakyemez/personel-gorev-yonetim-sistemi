import 'package:intl/intl.dart';

class DateFormatter {
  static final _short = DateFormat("dd.MM.yyyy", "tr_TR");
  static final _long = DateFormat("d MMMM yyyy", "tr_TR");

  static final _dateTime = DateFormat("dd.MM.yyyy HH:mm", "tr_TR");

  static String short(DateTime date) {
    return _short.format(date);
  }

  static String longDate(DateTime date) {
    return _long.format(date);
  }

  static String formatDateTime(DateTime date) {
    return _dateTime.format(date);
  }
}
