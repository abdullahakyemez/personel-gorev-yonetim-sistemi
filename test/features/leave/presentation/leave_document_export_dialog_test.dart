import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/dialogs/leave_document_export_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/application/personnel_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/application/settings_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/domain/models/app_settings.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final samplePerson = Personnel(
    id: 1,
    registryNumber: '318627',
    fullName: 'Ulvi GÖNÜLTAŞ',
    rank: 'Polis Memuru',
    title: 'Memur',
    department: 'Asayiş Şube Müdürlüğü',
    branch: 'Hırsızlık Büro Amirliği',
    phone: '0 506 845 06 96',
    email: 'ulvi@example.com',
    address: 'Gördes / MANİSA',
    startDate: DateTime(2020, 1, 1),
    status: PersonnelStatus.duty,
  );

  final deputyPerson = Personnel(
    id: 2,
    registryNumber: '445566',
    fullName: 'Ahmet YILMAZ',
    rank: 'Komiser',
    title: 'Grup Amiri',
    department: 'Asayiş Şube Müdürlüğü',
    branch: 'Hırsızlık Büro Amirliği',
    phone: '0 555 111 22 33',
    email: 'ahmet@example.com',
    address: 'ANKARA',
    startDate: DateTime(2018, 1, 1),
    status: PersonnelStatus.duty,
  );

  final sampleLeave = Leave(
    id: 'leave-1',
    personnelId: 1,
    type: LeaveType.annual,
    startDate: DateTime(2026, 8, 24),
    endDate: DateTime(2026, 9, 11),
    description: 'Yıllık izin',
    address: 'Gördes / MANİSA',
  );

  Widget createWidgetUnderTest() {
    return ProviderScope(
      overrides: [
        personnelListProvider.overrideWith((ref) async => [samplePerson, deputyPerson]),
        settingsProvider.overrideWith(
          () => _FakeSettingsNotifier(
            AppSettings.defaults().copyWith(
              defaultAmirName: 'Abdullah HAKYEMEZ',
              defaultAmirRank: 'Başkomiser',
              defaultAmirTitle: 'Büro Amiri',
            ),
          ),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: LeaveDocumentExportDialog(
            leave: sampleLeave,
            person: samplePerson,
          ),
        ),
      ),
    );
  }

  group('LeaveDocumentExportDialog Widget Tests', () {
    testWidgets('renders modal header, defaults and segmented buttons', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('İzin Belgesi Oluştur (Word)'), findsOneWidget);
      expect(find.text('Büro Amiri (Asil)'), findsOneWidget);
      expect(find.text('Büro Amir Vekili (Vekil)'), findsOneWidget);
      expect(find.text('Abdullah HAKYEMEZ'), findsWidgets);
      expect(find.text('Başkomiser'), findsWidgets);
      expect(find.text('Hırsızlık Büro Amiri'), findsWidgets);
      expect(find.text('ASİLEN İMZA'), findsOneWidget);
    });

    testWidgets('switching to Büro Amir Vekili updates title and preview badge', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Vekil segmentine tıkla
      await tester.tap(find.text('Büro Amir Vekili (Vekil)'));
      await tester.pumpAndSettle();

      expect(find.text('VEKALETEN İMZA'), findsOneWidget);
      expect(find.text('Hırsızlık Büro Amir V.'), findsWidgets);
    });

    testWidgets('selecting a deputy personnel fills their name and rank automatically', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Vekil segmentine tıkla
      await tester.tap(find.text('Büro Amir Vekili (Vekil)'));
      await tester.pumpAndSettle();

      // Dropdown'ı aç
      await tester.tap(find.byType(DropdownButtonFormField<Personnel?>));
      await tester.pumpAndSettle();

      // Ahmet YILMAZ'ı seç
      await tester.tap(find.text('Ahmet YILMAZ (Komiser) - Hırsızlık Büro Amirliği').last);
      await tester.pumpAndSettle();

      // Alanların Ahmet YILMAZ ve Komiser ile dolduğunu doğrula
      expect(find.text('Ahmet YILMAZ'), findsWidgets);
      expect(find.text('Komiser'), findsWidgets);
      expect(find.text('Hırsızlık Büro Amir V.'), findsWidgets);
    });
  });
}

class _FakeSettingsNotifier extends SettingsNotifier {
  final AppSettings _initial;
  _FakeSettingsNotifier(this._initial);

  @override
  Future<AppSettings> build() async => _initial;
}
