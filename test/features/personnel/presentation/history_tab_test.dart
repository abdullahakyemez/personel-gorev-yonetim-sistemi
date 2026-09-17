import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_history_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel_history.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/presentation/widgets/personnel_detail/tabs/history_tab.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('tr_TR', null);
  });

  final testPerson = Personnel(
    id: 10,
    registryNumber: '998877',
    fullName: 'Kemal Sunal',
    rank: 'Komiser',
    title: 'Büro Amiri',
    branch: 'Asayiş',
    department: 'Gasp',
    startDate: DateTime(2020, 1, 1),
    phone: '05551234567',
    email: 'kemal@pgys.gov.tr',
    address: 'Ankara',
    status: PersonnelStatus.duty,
  );

  group('HistoryTab Widget Tests', () {
    testWidgets('renders empty state when history list is empty', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            personnelHistoryProvider(10).overrideWith(
              (ref) => Future.value(<PersonnelHistory>[]),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: HistoryTab(person: testPerson),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('İşlem Geçmişi'), findsOneWidget);
      expect(find.text('Henüz geçmiş kaydı bulunmuyor.'), findsOneWidget);
    });

    testWidgets('renders history entries with action labels, descriptions and icons', (tester) async {
      final now = DateTime(2025, 5, 20, 14, 30);
      final historyItems = [
        PersonnelHistory(
          id: 'h1',
          personnelId: 10,
          action: PersonnelHistoryAction.taskAssigned,
          description: 'Görev personele atandı: Özel Koruma (20.05.2025 - 22.05.2025).',
          createdAt: now,
        ),
        PersonnelHistory(
          id: 'h2',
          personnelId: 10,
          action: PersonnelHistoryAction.leaveAdded,
          description: 'Yıllık İzin eklendi: 01.06.2025 - 10.06.2025 (10 gün).',
          createdAt: now.subtract(const Duration(days: 1)),
        ),
        PersonnelHistory(
          id: 'h3',
          personnelId: 10,
          action: PersonnelHistoryAction.personnelUpdated,
          description: 'Kemal Sunal güncellendi (Rütbe: Komiser Yardımcısı -> Komiser).',
          createdAt: now.subtract(const Duration(days: 5)),
        ),
        PersonnelHistory(
          id: 'h4',
          personnelId: 10,
          action: PersonnelHistoryAction.personnelCreated,
          description: 'Kemal Sunal personel kaydı oluşturuldu.',
          createdAt: now.subtract(const Duration(days: 30)),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            personnelHistoryProvider(10).overrideWith(
              (ref) => Future.value(historyItems),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: SingleChildScrollView(
                child: HistoryTab(person: testPerson),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('İşlem Geçmişi'), findsOneWidget);
      expect(find.text('Görev Atandı'), findsOneWidget);
      expect(find.text('Görev personele atandı: Özel Koruma (20.05.2025 - 22.05.2025).'), findsOneWidget);

      expect(find.text('İzin Eklendi'), findsOneWidget);
      expect(find.text('Yıllık İzin eklendi: 01.06.2025 - 10.06.2025 (10 gün).'), findsOneWidget);

      expect(find.text('Personel Güncellendi'), findsOneWidget);
      expect(find.text('Kemal Sunal güncellendi (Rütbe: Komiser Yardımcısı -> Komiser).'), findsOneWidget);

      expect(find.text('Personel Oluşturuldu'), findsOneWidget);
      expect(find.text('Kemal Sunal personel kaydı oluşturuldu.'), findsOneWidget);

      expect(find.byType(CircleAvatar), findsNWidgets(4));
    });
  });
}
