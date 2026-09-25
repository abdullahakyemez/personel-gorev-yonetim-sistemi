import 'package:drift/drift.dart';

class PersonnelTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Genel Bilgiler
  TextColumn get registryNumber => text()();
  TextColumn get fullName => text()();
  TextColumn get rank => text()();
  TextColumn get title => text()();

  // Kurum Bilgileri
  TextColumn get branch => text()();
  TextColumn get department => text()();

  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get officeStartDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();

  // İletişim
  TextColumn get phone => text()();
  TextColumn get email => text()();
  TextColumn get address => text()();

  // Ek Bilgiler
  TextColumn get bloodType => text().nullable()();
  TextColumn get relativeName => text().nullable()();
  TextColumn get relativePhone => text().nullable()();

  // Çalışma Düzeni
  TextColumn get workScheduleType => text().nullable()();

  IntColumn get workScheduleDutyDays => integer().nullable()();

  IntColumn get workScheduleRestDays => integer().nullable()();

  DateTimeColumn get workScheduleStartDate => dateTime().nullable()();

  // Geçici durum.
  // Günlük durum sistemi oluşturulduğunda kullanılmayacak.
  TextColumn get status => text().withDefault(const Constant('duty'))();

  TextColumn get profilePhoto => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {registryNumber},
  ];
}
