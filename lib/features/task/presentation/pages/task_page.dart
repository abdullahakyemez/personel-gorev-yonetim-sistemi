import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/page_header.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageHeader(title: "Görevler", subtitle: "Görev Yönetim Ekranı"),
        ],
      ),
    );
  }
}
