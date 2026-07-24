import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/page_header.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(title: "Raporlar", subtitle: "Rapor Yönetim Ekranı"),
        ],
      ),
    );
  }
}
