import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/page_header.dart';

class LeavePage extends StatelessWidget {
  const LeavePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(title: "İzinler", subtitle: "İzin Yönetim Ekranı"),
        ],
      ),
    );
  }
}
