import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_status_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_category_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task_category.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/task_provider.dart';
import '../../domain/models/task.dart';

class TaskDetailDialog extends ConsumerStatefulWidget {
  final Task task;
  final Personnel? personnel;

  const TaskDetailDialog({super.key, required this.task, this.personnel});

  @override
  ConsumerState<TaskDetailDialog> createState() => _TaskDetailDialogState();
}

class _TaskDetailDialogState extends ConsumerState<TaskDetailDialog> {
  late final TextEditingController titleController;
  late final TextEditingController descriptionController;
  bool _editMode = false;
  TaskCategory? _selectedCategory;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  Future<void> _saveTask() async {
    final updateTask = widget.task.copyWith(
      title: _selectedCategory?.label ?? widget.task.title,
      description: descriptionController.text.trim(),
      startDate: _selectedStartDate ?? widget.task.startDate,
      endDate: _selectedEndDate ?? widget.task.endDate,
    );

    await ref.read(taskControllerProvider.notifier).updateTask(updateTask);
    if (!mounted) return;
    setState(() {
      _editMode = false;
    });
  }

  Future<void> _selectDate({required bool isStartDate}) async {
    final initialDate = isStartDate
        ? (_selectedStartDate ?? DateTime.now())
        : (_selectedEndDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      if (isStartDate) {
        _selectedStartDate = picked;

        // Bitiş tarihi başlangıçtan önce olmasın.
        if (_selectedEndDate != null && _selectedEndDate!.isBefore(picked)) {
          _selectedEndDate = picked;
        }
      } else {
        _selectedEndDate = picked;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(
      text: widget.task.description,
    );
    _selectedCategory = widget.task.category;
    _selectedStartDate = widget.task.startDate;
    _selectedEndDate = widget.task.endDate;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 650,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Görev Detayı",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),

                const SizedBox(height: 24),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Başlık",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),

                    const SizedBox(height: 6),

                    _editMode
                        ? DropdownButtonFormField<TaskCategory>(
                            initialValue: _selectedCategory,
                            decoration: const InputDecoration(border: OutlineInputBorder()),
                            items: TaskCategory.values.map((category) => DropdownMenuItem(value: category, child: Text(category.label))).toList(),
                            onChanged: (value) => setState(() => _selectedCategory = value),
                          )
                        : Text(
                            widget.task.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),

                    const Divider(),
                  ],
                ),

                const SizedBox(height: 12),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Açıklama",
                      style: Theme.of(context).textTheme.labelMedium,
                    ),

                    const SizedBox(height: 6),

                    _editMode
                        ? TextField(
                            controller: descriptionController,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          )
                        : Text(widget.task.description),

                    const Divider(),
                  ],
                ),

                const SizedBox(height: 12),
                buildInfo(
                  context,
                  "Personel",
                  widget.personnel?.fullName ?? "-",
                ),

                const SizedBox(height: 12),
                _editMode
                    ? DropdownButtonFormField<TaskCategory>(
                        initialValue: _selectedCategory,
                        decoration: const InputDecoration(
                          labelText: "Görev Türü",
                          border: OutlineInputBorder(),
                        ),
                        items: TaskCategory.values.map((category) {
                          return DropdownMenuItem(
                            value: category,
                            child: Text(category.label),
                          );
                        }).toList(),
                        onChanged: (value) => setState(() => _selectedCategory = value),
                      )
                    : buildInfo(context, "Durum", widget.task.status.label),
                const SizedBox(height: 12),

                _editMode
                    ? ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Başlangıç"),
                        subtitle: Text(
                          DateFormatter.short(_selectedStartDate!),
                        ),
                        trailing: const Icon(Icons.calendar_month),
                        onTap: () => _selectDate(isStartDate: true),
                      )
                    : buildInfo(
                        context,
                        "Başlangıç",
                        DateFormatter.short(widget.task.startDate),
                      ),
                const SizedBox(height: 12),
                _editMode
                    ? ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Bitiş"),
                        subtitle: Text(DateFormatter.short(_selectedEndDate!)),
                        trailing: const Icon(Icons.calendar_month),
                        onTap: () => _selectDate(isStartDate: false),
                      )
                    : buildInfo(
                        context,
                        "Bitiş",
                        DateFormatter.short(widget.task.endDate),
                      ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () async {
                          if (_editMode) {
                            await _saveTask();
                          } else {
                            setState(() {
                              _editMode = true;
                            });
                          }
                        },
                        icon: Icon(_editMode ? Icons.save : Icons.edit),
                        label: Text(_editMode ? "Kaydet" : "Düzenle"),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Kapat"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfo(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelMedium),

          const SizedBox(height: 4),

          Text(value, style: Theme.of(context).textTheme.bodyLarge),

          const Divider(),
        ],
      ),
    );
  }
}
