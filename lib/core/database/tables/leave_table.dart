import 'package:drift/drift.dart';

class LeaveTable extends Table {
  TextColumn get id => text()();

  TextColumn get personnelId => text()();

  DateTimeColumn get startDate => dateTime()();

  DateTimeColumn get endDate => dateTime()();

  TextColumn get type => text()();

  TextColumn get description => text()();

  TextColumn get address => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
