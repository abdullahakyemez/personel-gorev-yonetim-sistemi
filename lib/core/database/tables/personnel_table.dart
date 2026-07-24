import 'package:drift/drift.dart';

class PersonnelTable extends Table {
  // Primary Key
  IntColumn get id => integer().autoIncrement()();

  // Kimlik Bilgileri
  TextColumn get registryNumber => text()();

  TextColumn get fullName => text()();

  TextColumn get phone => text()();

  // Kurum Bilgileri
  TextColumn get rank => text()();

  TextColumn get department => text()();

  TextColumn get branch => text()();

  // Görev Durumu
  BoolColumn get onDuty => boolean().withDefault(const Constant(true))();

  // İleride eklenecek alanlar
  TextColumn get email => text().nullable()();

  TextColumn get tcIdentity => text().nullable()();

  TextColumn get title => text().nullable()();

  TextColumn get profilePhoto => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
