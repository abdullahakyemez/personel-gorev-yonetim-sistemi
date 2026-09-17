import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_confirm_dialog.dart';

void main() {
  group('PGYSConfirmDialog Widget Tests', () {
    Widget buildTestWidget({
      required String title,
      required String message,
      List<String>? details,
      String confirmText = 'Sil',
      String cancelText = 'Vazgeç',
      bool isDestructive = true,
      void Function(bool?)? onResult,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => Center(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await showPGYSConfirmDialog(
                    context: context,
                    title: title,
                    message: message,
                    details: details,
                    confirmText: confirmText,
                    cancelText: cancelText,
                    isDestructive: isDestructive,
                  );
                  onResult?.call(result);
                },
                child: const Text('Open Dialog'),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('Renders title, message, and details list', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          title: 'Personel Sil',
          message: 'Ahmet Yılmaz isimli personeli silmek istediğinize emin misiniz?',
          details: [
            '2 adet izin kaydı kalıcı olarak silinecektir',
            '1 adet görev ataması kaldırılacaktır',
          ],
        ),
      );

      // Open dialog
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Personel Sil'), findsOneWidget);
      expect(
        find.text('Ahmet Yılmaz isimli personeli silmek istediğinize emin misiniz?'),
        findsOneWidget,
      );
      expect(find.text('İlişkili veriler:'), findsOneWidget);
      expect(
        find.text('2 adet izin kaydı kalıcı olarak silinecektir'),
        findsOneWidget,
      );
      expect(
        find.text('1 adet görev ataması kaldırılacaktır'),
        findsOneWidget,
      );
      expect(find.text('Bu işlem geri alınamaz.'), findsOneWidget);
      expect(find.text('Vazgeç'), findsOneWidget);
      expect(find.text('Sil'), findsOneWidget);
    });

    testWidgets('Pressing Vazgeç pops dialog returning false', (tester) async {
      bool? dialogResult;

      await tester.pumpWidget(
        buildTestWidget(
          title: 'Görev Sil',
          message: 'Bu görevi silmek istiyor musunuz?',
          onResult: (res) => dialogResult = res,
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Vazgeç'));
      await tester.pumpAndSettle();

      expect(dialogResult, isFalse);
      expect(find.byType(PGYSConfirmDialog), findsNothing);
    });

    testWidgets('Pressing confirm button pops dialog returning true', (tester) async {
      bool? dialogResult;

      await tester.pumpWidget(
        buildTestWidget(
          title: 'İzin Sil',
          message: 'Bu izni silmek istiyor musunuz?',
          confirmText: 'Onayla',
          onResult: (res) => dialogResult = res,
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Onayla'));
      await tester.pumpAndSettle();

      expect(dialogResult, isTrue);
      expect(find.byType(PGYSConfirmDialog), findsNothing);
    });

    testWidgets('Non-destructive dialog hides irreversible warning and uses check icon', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          title: 'Durum Güncelle',
          message: 'Personel durumunu güncellemek istiyor musunuz?',
          confirmText: 'Güncelle',
          isDestructive: false,
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Bu işlem geri alınamaz.'), findsNothing);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.text('Güncelle'), findsOneWidget);
    });
  });
}
