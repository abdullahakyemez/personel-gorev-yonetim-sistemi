import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/feedback/pgys_feedback.dart';

import '../../application/leave_provider.dart';
import '../../domain/extensions/leave_type_extension.dart';
import '../../domain/models/leave.dart';

class LeaveDialog extends ConsumerStatefulWidget {
  final int personnelId;
  final Leave? leave;

  const LeaveDialog({super.key, required this.personnelId, this.leave});

  bool get isEdit => leave != null;

  @override
  ConsumerState<LeaveDialog> createState() => _LeaveDialogState();
}

class _LeaveDialogState extends ConsumerState<LeaveDialog> {
  late LeaveType _type;
  late DateTime _startDate;
  late DateTime _endDate;

  late final TextEditingController _descriptionController;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    final leave = widget.leave;

    _type = leave?.type ?? LeaveType.annual;
    _startDate = leave?.startDate ?? DateTime.now();
    _endDate = leave?.endDate ?? DateTime.now();

    _descriptionController = TextEditingController(
      text: leave?.description ?? '',
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      _startDate = picked;

      if (_endDate.isBefore(picked)) {
        _endDate = picked;
      }
    });
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate.isBefore(_startDate) ? _startDate : _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );

    if (picked == null) return;

    setState(() {
      _endDate = picked;
    });
  }

  Future<void> _save() async {
    if (_endDate.isBefore(_startDate)) {
      PGYSFeedback.showError(
        context,
        "Bitiş tarihi başlangıç tarihinden önce olamaz.",
      );
      return;
    }

    setState(() {
      _saving = true;
    });

    final leave =
        widget.leave?.copyWith(
          startDate: _startDate,
          endDate: _endDate,
          type: _type,
          description: _descriptionController.text.trim(),
        ) ??
        Leave(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          personnelId: widget.personnelId,
          startDate: _startDate,
          endDate: _endDate,
          type: _type,
          description: _descriptionController.text.trim(),
        );

    try {
      final controller = ref.read(leaveControllerProvider.notifier);

      if (widget.isEdit) {
        await controller.updateLeave(leave);
      } else {
        await controller.addLeave(leave);
      }

      if (!mounted) return;

      Navigator.of(context).pop();
      PGYSFeedback.showSuccess(
        context,
        widget.isEdit
            ? "İzin başarıyla güncellendi."
            : "İzin başarıyla kaydedildi.",
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      PGYSFeedback.showError(
        context,
        widget.isEdit
            ? "İzin güncellenemedi: $e"
            : "İzin kaydedilemedi: $e",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.isEdit ? "İzin Düzenle" : "İzin Ekle"),
      content: SizedBox(
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<LeaveType>(
                initialValue: _type,
                decoration: const InputDecoration(
                  labelText: "İzin Türü",
                  border: OutlineInputBorder(),
                ),
                items: LeaveType.values.map((type) {
                  return DropdownMenuItem(value: type, child: Text(type.label));
                }).toList(),
                onChanged: _saving
                    ? null
                    : (value) {
                        if (value == null) return;

                        setState(() {
                          _type = value;
                        });
                      },
              ),

              const SizedBox(height: 16),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Başlangıç Tarihi"),
                subtitle: Text(
                  "${_startDate.day.toString().padLeft(2, '0')}."
                  "${_startDate.month.toString().padLeft(2, '0')}."
                  "${_startDate.year}",
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: _saving ? null : _selectStartDate,
              ),

              const Divider(),

              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("Bitiş Tarihi"),
                subtitle: Text(
                  "${_endDate.day.toString().padLeft(2, '0')}."
                  "${_endDate.month.toString().padLeft(2, '0')}."
                  "${_endDate.year}",
                ),
                trailing: const Icon(Icons.calendar_month),
                onTap: _saving ? null : _selectEndDate,
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _descriptionController,
                enabled: !_saving,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Açıklama",
                  hintText: "İzin hakkında açıklama...",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        OutlinedButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text("İptal"),
        ),
        FilledButton.icon(
          onPressed: _saving ? null : _save,
          icon: _saving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.save),
          label: Text(_saving ? "Kaydediliyor..." : "Kaydet"),
        ),
      ],
    );
  }
}
