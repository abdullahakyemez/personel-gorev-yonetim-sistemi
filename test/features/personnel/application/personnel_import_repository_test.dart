import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/data/repositories/personnel_history_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/data/repositories/personnel_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel_history.dart';

void main() {
  late AppDatabase db;
  late PersonnelHistoryRepositoryImpl historyRepo;
  late PersonnelRepositoryImpl personnelRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    historyRepo = PersonnelHistoryRepositoryImpl(db);
    personnelRepo = PersonnelRepositoryImpl(db, historyRepo);
  });

  tearDown(() async {
    await db.close();
  });

  final p1 = Personnel(
    id: null,
    registryNumber: '2001',
    fullName: 'Ahmet Yılmaz',
    rank: 'Polis Memuru',
    title: 'Memur',
    department: 'Asayiş Şube Müdürlüğü',
    branch: 'Cinayet Büro',
    phone: '5551112233',
    email: 'ahmet@example.com',
    address: 'Ankara',
    startDate: DateTime(2022, 1, 1),
    status: PersonnelStatus.duty,
  );

  final p2 = Personnel(
    id: null,
    registryNumber: '2002',
    fullName: 'Mehmet Öz',
    rank: 'Komiser',
    title: 'Grup Amiri',
    department: 'Asayiş Şube Müdürlüğü',
    branch: 'Devriye',
    phone: '5552223344',
    email: 'mehmet@example.com',
    address: 'İstanbul',
    startDate: DateTime(2021, 5, 1),
    status: PersonnelStatus.duty,
  );

  group('PersonnelRepository importPersonnelList Tests', () {
    test('imports new personnel successfully in transaction and records history', () async {
      final result = await personnelRepo.importPersonnelList(
        personnelList: [p1, p2],
        overwriteExisting: false,
      );

      expect(result.insertedCount, equals(2));
      expect(result.updatedCount, equals(0));
      expect(result.skippedCount, equals(0));

      final all = await personnelRepo.getAllPersonnel();
      expect(all.length, equals(2));
      expect(all.any((p) => p.registryNumber == '2001'), isTrue);
      expect(all.any((p) => p.registryNumber == '2002'), isTrue);

      final p1Record = all.firstWhere((p) => p.registryNumber == '2001');
      final historyList = await historyRepo.getByPersonnel(p1Record.id!);
      expect(historyList.isNotEmpty, isTrue);

      expect(historyList.first.action, equals(PersonnelHistoryAction.personnelCreated));
    });

    test('skips existing registry numbers when overwriteExisting is false', () async {
      // First insert p1
      await personnelRepo.addPersonnel(p1);

      // Now attempt import with p1 and p2, overwriteExisting = false
      final result = await personnelRepo.importPersonnelList(
        personnelList: [p1, p2],
        overwriteExisting: false,
      );

      expect(result.insertedCount, equals(1)); // only p2 inserted
      expect(result.skippedCount, equals(1)); // p1 skipped
      expect(result.updatedCount, equals(0));

      final all = await personnelRepo.getAllPersonnel();
      expect(all.length, equals(2));
    });

    test('updates existing registry numbers when overwriteExisting is true', () async {
      // First insert p1
      await personnelRepo.addPersonnel(p1);

      final modifiedP1 = p1.copyWith(
        fullName: 'Ahmet Yılmaz (GÜNCELLENDİ)',
        rank: 'Başkomiser',
      );

      final result = await personnelRepo.importPersonnelList(
        personnelList: [modifiedP1, p2],
        overwriteExisting: true,
      );

      expect(result.insertedCount, equals(1)); // p2 inserted
      expect(result.updatedCount, equals(1)); // p1 updated
      expect(result.skippedCount, equals(0));

      final all = await personnelRepo.getAllPersonnel();
      expect(all.length, equals(2));

      final updated = all.firstWhere((p) => p.registryNumber == '2001');
      expect(updated.fullName, equals('Ahmet Yılmaz (GÜNCELLENDİ)'));
      expect(updated.rank, equals('Başkomiser'));
    });
  });
}
