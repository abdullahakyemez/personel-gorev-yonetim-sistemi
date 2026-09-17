import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';
import 'package:personel_gorev_yonetim_sistemi/features/settings/presentation/widgets/lan_settings_section.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget createWidgetUnderTest() {
    return ProviderScope(
      child: MaterialApp(
        scaffoldMessengerKey: rootScaffoldMessengerKey,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: LanSettingsSection(),
            ),
          ),
        ),
      ),
    );
  }

  group('LanSettingsSection Widget Tests', () {
    testWidgets('renders segmented button and default standalone view', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Tek PC (Yerel)'), findsOneWidget);
      expect(find.text('Merkez Sunucu'), findsOneWidget);
      expect(find.text('İstemci PC'), findsOneWidget);
      expect(find.textContaining('Uygulama yalnızca bu bilgisayarda yerel olarak çalışmaktadır'), findsOneWidget);
    });

    testWidgets('switching to server mode shows server controls and IP display', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap Merkez Sunucu
      await tester.tap(find.text('Merkez Sunucu'));
      await tester.pumpAndSettle();

      expect(find.text('Sunucu Portu'), findsOneWidget);
      expect(find.text('Ağ Güvenlik Anahtarı (Token)'), findsOneWidget);
      expect(find.text('Sunucu Ayarlarını Kaydet'), findsOneWidget);
      expect(find.textContaining('Bu Bilgisayarın Yerel IP Adresi'), findsOneWidget);
    });

    testWidgets('switching to client mode shows client inputs and action buttons', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      // Tap İstemci PC
      await tester.tap(find.text('İstemci PC'));
      await tester.pumpAndSettle();

      expect(find.text('Merkez Sunucu IP Adresi'), findsOneWidget);
      expect(find.text('Bağlantıyı Test Et'), findsOneWidget);
      expect(find.text('Şimdi Eşitle'), findsOneWidget);
      expect(find.text('İstemci Ayarlarını Kaydet'), findsOneWidget);
      expect(find.text('Arka Planda Otomatik Senkronizasyon'), findsOneWidget);
    });
  });
}
