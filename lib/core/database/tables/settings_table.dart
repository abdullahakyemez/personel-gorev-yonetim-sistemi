import 'package:drift/drift.dart';

class SettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get appName => text()();

  TextColumn get dateFormat => text()();

  TextColumn get themeMode => text()();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
