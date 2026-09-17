import 'package:drift/drift.dart';
import 'personnel_table.dart';

class UserTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get username => text().unique()();
  TextColumn get passwordHash => text()();
  TextColumn get salt => text()();
  TextColumn get fullName => text()();
  TextColumn get role => text()(); // UserRole.name
  IntColumn get personnelId =>
      integer().references(PersonnelTable, #id, onDelete: KeyAction.setNull).nullable()();
  TextColumn get groupName => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get requiresPasswordChange =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastLoginAt => dateTime().nullable()();
}
