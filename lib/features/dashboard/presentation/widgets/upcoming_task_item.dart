import 'package:flutter/material.dart';
import '../../domain/models/upcoming_task.dart';

class UpcomingTaskItem extends StatelessWidget {
  final UpcomingTask task;

  const UpcomingTaskItem({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        task.urgent ? Icons.warning_amber_rounded : Icons.event_note_outlined,
        color: task.urgent ? Colors.orange : Colors.blue,
      ),
      title: Text(task.title),
      subtitle: Text(task.date),
    );
  }
}
