import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:personel_gorev_yonetim_sistemi/shell/widgets/app_custom_title_bar.dart';

void main() {
  testWidgets('AppCustomTitleBar renders title and action buttons', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AppCustomTitleBar(),
        ),
      ),
    );

    expect(find.text('Personel ve Görev Yönetim Sistemi'), findsOneWidget);
    expect(find.byIcon(Icons.remove_rounded), findsOneWidget);
    expect(find.byIcon(Icons.crop_square_rounded), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
  });
}
