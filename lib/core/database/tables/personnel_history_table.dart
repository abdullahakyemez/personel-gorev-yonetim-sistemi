import 'package:drift/drift.dart';

import 'personnel_table.dart';

class PersonnelHistoryTable extends Table {
  TextColumn get id => text()();

  IntColumn get personnelId =>
      integer().references(PersonnelTable, #id, onDelete: KeyAction.cascade)();

  TextColumn get action => text()();

  TextColumn get description => text()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
