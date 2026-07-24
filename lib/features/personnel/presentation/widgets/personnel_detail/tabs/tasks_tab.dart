import 'package:flutter/material.dart';

class TasksTab extends StatelessWidget {
  const TasksTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(48),
        child: Text(
          'Görevler modülü yakında eklenecek',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
