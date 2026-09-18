import 'package:intl/intl.dart';

class DateFormatter {
  static final _short = DateFormat("dd.MM.yyyy");
  static final _long = DateFormat("d MMMM yyyy", "tr_TR");
  static final _longWithDay = DateFormat("d MMMM yyyy EEEE", "tr_TR");

  static final _dateTime = DateFormat("dd.MM.yyyy HH:mm");

  static String short(DateTime date) {
    return _short.format(date);
  }

  static String iso(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  static String longDate(DateTime date) {
    try {
      return _long.format(date);
    } catch (_) {
      const months = [
        '',
        'Ocak',
        'Şubat',
        'Mart',
        'Nisan',
        'Mayıs',
        'Haziran',
        'Temmuz',
        'Ağustos',
        'Eylül',
        'Ekim',
        'Kasım',
        'Aralık',
      ];
      final monthName = (date.month >= 1 && date.month <= 12)
          ? months[date.month]
          : '${date.month}';
      return '${date.day} $monthName ${date.year}';
    }
  }

  static String longDateWithDay(DateTime date) {
    try {
      return _longWithDay.format(date);
    } catch (_) {
      const months = [
        '',
        'Ocak',
        'Şubat',
        'Mart',
        'Nisan',
        'Mayıs',
        'Haziran',
        'Temmuz',
        'Ağustos',
        'Eylül',
        'Ekim',
        'Kasım',
        'Aralık',
      ];
      const days = [
        '',
        'Pazartesi',
        'Salı',
        'Çarşamba',
        'Perşembe',
        'Cuma',
        'Cumartesi',
        'Pazar',
      ];
      final monthName = (date.month >= 1 && date.month <= 12)
          ? months[date.month]
          : '${date.month}';
      final dayName = (date.weekday >= 1 && date.weekday <= 7)
          ? days[date.weekday]
          : '';
      return '${date.day} $monthName ${date.year} $dayName';
    }
  }

  static String formatDateTime(DateTime date) {
    return _dateTime.format(date);
  }
}
