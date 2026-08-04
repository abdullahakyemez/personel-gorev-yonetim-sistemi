import 'package:intl/intl.dart';

class DateFormatter {
  static final _short = DateFormat("dd.MM.yyyy", "tr_TR");

  static String short(DateTime date) {
    return _short.format(date);
  }
}
