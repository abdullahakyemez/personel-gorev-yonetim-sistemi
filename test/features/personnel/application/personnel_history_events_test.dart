import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/data/repositories/leave_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/data/repositories/personnel_history_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/data/repositories/personnel_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel_history.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/data/repositories/task_repository_impl.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_status.dart';

void main() {
  late AppDatabase db;
  late PersonnelHistoryRepositoryImpl historyRepo;
  late PersonnelRepositoryImpl personnelRepo;
  late LeaveRepositoryImpl leaveRepo;
  late TaskRepositoryImpl taskRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    historyRepo = PersonnelHistoryRepositoryImpl(db);
    personnelRepo = PersonnelRepositoryImpl(db, historyRepo);
    leaveRepo = LeaveRepositoryImpl(db, historyRepo);
    taskRepo = TaskRepositoryImpl(db, historyRepo);
  });

  tearDown(() async {
    await db.close();
  });

  group('Personnel History Events & Audit Trail Tests', () {
    test('addPersonnel records personnelCreated history entry', () async {
      final personWithDate = Personnel(
        id: null,
        registryNumber: '1001',
        fullName: 'Ali Kaya',
        rank: 'Polis Memuru',
        title: 'Memur',
        branch: 'Asayiş',
        department: 'Devriye',
        startDate: DateTime(2022, 1, 1),
        phone: '05551112233',
        email: 'ali@test.com',
        address: 'Ankara',
        status: PersonnelStatus.duty,
      );

      await personnelRepo.addPersonnel(personWithDate);

      final all = await personnelRepo.getAllPersonnel();
      expect(all.length, 1);
      final savedId = all.first.id!;

      final history = await historyRepo.getByPersonnel(savedId);
      expect(history.length, 1);
      expect(history.first.action, PersonnelHistoryAction.personnelCreated);
      expect(history.first.description, contains('Ali Kaya personel kaydı oluşturuldu.'));
    });

    test('updatePersonnel tracks field deltas in history description', () async {
      final initialPerson = Personnel(
        id: null,
        registryNumber: '1002',
        fullName: 'Mehmet Demir',
        rank: 'Polis Memuru',
        title: 'Memur',
        branch: 'Asayiş',
        department: 'Devriye',
        startDate: DateTime(2020, 5, 1),
        phone: '05552223344',
        email: 'mehmet@test.com',
        address: 'İstanbul',
        status: PersonnelStatus.duty,
      );
      await personnelRepo.addPersonnel(initialPerson);
      final all = await personnelRepo.getAllPersonnel();
      final savedPerson = all.first;

      final updatedPerson = Personnel(
        id: savedPerson.id,
        registryNumber: '1002',
        fullName: 'Mehmet Demir',
        rank: 'Komiser',
        title: 'Büro Amiri',
        branch: 'Trafik',
        department: 'Trafik Denetleme',
        startDate: DateTime(2020, 5, 1),
        phone: '05559998877',
        email: 'mehmet@test.com',
        address: 'İstanbul',
        status: PersonnelStatus.duty,
      );

      await personnelRepo.updatePersonnel(updatedPerson);

      final history = await historyRepo.getByPersonnel(savedPerson.id!);
      expect(history.length, 2);

      final latest = history.first;
      expect(latest.action, PersonnelHistoryAction.personnelUpdated);
      expect(latest.description, contains('Rütbe: Polis Memuru -> Komiser'));
      expect(latest.description, contains('Unvan: Memur -> Büro Amiri'));
      expect(latest.description, contains('Branş: Asayiş -> Trafik'));
      expect(latest.description, contains('Birim: Devriye -> Trafik Denetleme'));
      expect(latest.description, contains('Telefon güncellendi'));
    });

    test('deletePersonnel removes personnel and cascades cleanly', () async {
      final person = Personnel(
        id: null,
        registryNumber: '1003',
        fullName: 'Ayşe Çelik',
        rank: 'Başpolis',
        title: 'Grup Amiri',
        branch: 'Narkotik',
        department: 'Soruşturma',
        startDate: DateTime(2018, 3, 15),
        phone: '05553334455',
        email: 'ayse@test.com',
        address: 'İzmir',
        status: PersonnelStatus.duty,
      );
      await personnelRepo.addPersonnel(person);
      final all = await personnelRepo.getAllPersonnel();
      final personId = all.first.id!;

      await personnelRepo.deletePersonnel(personId);

      final remaining = await personnelRepo.getAllPersonnel();
      expect(remaining.isEmpty, isTrue);
    });

    test('deleteManyPersonnel removes multiple personnel in transaction', () async {
      final p1 = Personnel(
        id: null,
        registryNumber: '1003A',
        fullName: 'Ayşe 1',
        rank: 'Polis Memuru',
        title: 'Memur',
        branch: 'Asayiş',
        department: 'Büro',
        startDate: DateTime(2020, 1, 1),
        phone: '05551111111',
        email: 'a1@test.com',
        address: 'İzmir',
        status: PersonnelStatus.duty,
      );
      final p2 = Personnel(
        id: null,
        registryNumber: '1003B',
        fullName: 'Ayşe 2',
        rank: 'Polis Memuru',
        title: 'Memur',
        branch: 'Asayiş',
        department: 'Büro',
        startDate: DateTime(2020, 1, 1),
        phone: '05552222222',
        email: 'a2@test.com',
        address: 'İzmir',
        status: PersonnelStatus.duty,
      );
      await personnelRepo.addPersonnel(p1);
      await personnelRepo.addPersonnel(p2);
      final all = await personnelRepo.getAllPersonnel();
      expect(all.length, 2);

      await personnelRepo.deleteManyPersonnel(all.map((p) => p.id!).toList());

      final remaining = await personnelRepo.getAllPersonnel();
      expect(remaining.isEmpty, isTrue);
    });

    test('Leave operations write detailed history logs with Turkish labels and dates', () async {
      final person = Personnel(
        id: null,
        registryNumber: '1004',
        fullName: 'Fatma Şahin',
        rank: 'Polis Memuru',
        title: 'Memur',
        branch: 'Güvenlik',
        department: 'Koruma',
        startDate: DateTime(2019, 1, 1),
        phone: '05554445566',
        email: 'fatma@test.com',
        address: 'Bursa',
        status: PersonnelStatus.duty,
      );
      await personnelRepo.addPersonnel(person);
      final all = await personnelRepo.getAllPersonnel();
      final personId = all.first.id!;

      // Add leave
      final leave = Leave(
        id: 'leave-100',
        personnelId: personId,
        startDate: DateTime(2025, 6, 1),
        endDate: DateTime(2025, 6, 10),
        type: LeaveType.annual,
        description: 'Yıllık izin kullanımı',
      );
      await leaveRepo.add(leave);

      var history = await historyRepo.getByPersonnel(personId);
      expect(history.first.action, PersonnelHistoryAction.leaveAdded);
      expect(history.first.description, contains('Yıllık İzin eklendi: 01.06.2025 - 10.06.2025 (10 gün).'));

      // Update leave
      final updatedLeave = leave.copyWith(
        endDate: DateTime(2025, 6, 15),
      );
      await leaveRepo.update(updatedLeave);

      history = await historyRepo.getByPersonnel(personId);
      expect(history.first.action, PersonnelHistoryAction.leaveUpdated);
      expect(history.first.description, contains('Yıllık İzin güncellendi: 01.06.2025 - 15.06.2025 (15 gün).'));

      // Delete leave
      await leaveRepo.delete(leave.id);
      history = await historyRepo.getByPersonnel(personId);
      expect(history.first.action, PersonnelHistoryAction.leaveDeleted);
      expect(history.first.description, contains('Yıllık İzin silindi: 01.06.2025 - 15.06.2025 (15 gün).'));
    });

    test('Task operations log creation, updates, and assignment changes', () async {
      final person1 = Personnel(
        id: null,
        registryNumber: '2001',
        fullName: 'Hasan Ak',
        rank: 'Polis Memuru',
        title: 'Memur',
        branch: 'Asayiş',
        department: 'Devriye',
        startDate: DateTime(2021, 1, 1),
        phone: '05557778899',
        email: 'hasan@test.com',
        address: 'Adana',
        status: PersonnelStatus.duty,
      );
      final person2 = Personnel(
        id: null,
        registryNumber: '2002',
        fullName: 'Kemal Kara',
        rank: 'Polis Memuru',
        title: 'Memur',
        branch: 'Asayiş',
        department: 'Devriye',
        startDate: DateTime(2021, 1, 1),
        phone: '05558889900',
        email: 'kemal@test.com',
        address: 'Adana',
        status: PersonnelStatus.duty,
      );
      await personnelRepo.addPersonnel(person1);
      await personnelRepo.addPersonnel(person2);
      final personnel = await personnelRepo.getAllPersonnel();
      final id1 = personnel.firstWhere((p) => p.registryNumber == '2001').id!;
      final id2 = personnel.firstWhere((p) => p.registryNumber == '2002').id!;

      // Add task assigned to person 1
      final task = Task(
        id: 'task-10',
        personnelIds: [id1],
        title: 'Stadyum Çevre Güvenliği',
        description: 'Maç tedbirleri',
        status: TaskStatus.inProgress,
        startDate: DateTime(2025, 4, 1),
        endDate: DateTime(2025, 4, 2),
      );
      await taskRepo.add(task);

      var history1 = await historyRepo.getByPersonnel(id1);
      expect(history1.first.action, PersonnelHistoryAction.taskAdded);
      expect(history1.first.description, contains('Görev eklendi: Stadyum Çevre Güvenliği (01.04.2025 - 02.04.2025).'));

      // Reassign task to person 2 and remove person 1
      final reassignedTask = task.copyWith(
        personnelIds: [id2],
      );
      await taskRepo.update(reassignedTask);

      history1 = await historyRepo.getByPersonnel(id1);
      expect(history1.first.action, PersonnelHistoryAction.taskUnassigned);
      expect(history1.first.description, contains('Görev personelden kaldırıldı: Stadyum Çevre Güvenliği.'));

      var history2 = await historyRepo.getByPersonnel(id2);
      expect(history2.first.action, PersonnelHistoryAction.taskAssigned);
      expect(history2.first.description, contains('Görev personele atandı: Stadyum Çevre Güvenliği (01.04.2025 - 02.04.2025).'));

      // Delete task
      await taskRepo.delete(task.id!);
      history2 = await historyRepo.getByPersonnel(id2);
      expect(history2.first.action, PersonnelHistoryAction.taskDeleted);
      expect(history2.first.description, contains('Görev silindi: Stadyum Çevre Güvenliği.'));
    });
  });
}
