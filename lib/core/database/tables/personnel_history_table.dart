import 'package:drift/drift.dart';

class PersonnelHistoryTable extends Table {
  TextColumn get id => text()();

  TextColumn get personnelId => text()();

  TextColumn get action => text()();

  TextColumn get description => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
