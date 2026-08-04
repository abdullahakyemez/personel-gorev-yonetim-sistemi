import 'package:flutter/material.dart';

class TaskDetailInfoRow extends StatelessWidget {
  final String title;
  final Widget value;

  const TaskDetailInfoRow({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(title, style: Theme.of(context).textTheme.titleSmall),
          ),

          Expanded(child: value),
        ],
      ),
    );
  }
}
