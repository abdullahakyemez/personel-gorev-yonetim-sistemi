import 'package:flutter/material.dart';

import 'package:personel_gorev_yonetim_sistemi/core/utils/date_formatter.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';

class LeaveFormController {
  final formKey = GlobalKey<FormState>();

  // ------------------------------------------------------------
  // TEXT CONTROLLERS
  // ------------------------------------------------------------

  final descriptionController = TextEditingController();

  final startDateController = TextEditingController();

  final endDateController = TextEditingController();

  // ------------------------------------------------------------
  // SEÇİMLER
  // ------------------------------------------------------------

  String? personnelId;

  LeaveType? type;

  // ------------------------------------------------------------
  // TARİHLER
  // ------------------------------------------------------------

  DateTime? startDate;

  DateTime? endDate;

  // ------------------------------------------------------------
  // LOAD
  // ------------------------------------------------------------

  void load(Leave leave) {
    personnelId = leave.personnelId;

    type = leave.type;

    startDate = leave.startDate;

    endDate = leave.endDate;

    descriptionController.text = leave.description;

    startDateController.text = DateFormatter.short(leave.startDate);

    endDateController.text = DateFormatter.short(leave.endDate);
  }

  // ------------------------------------------------------------
  // BAŞLANGIÇ TARİHİ
  // ------------------------------------------------------------

  Future<void> pickStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    startDate = picked;

    startDateController.text = DateFormatter.short(picked);

    // Başlangıç tarihi bitiş tarihinden sonraya geçemez.
    if (endDate != null && endDate!.isBefore(picked)) {
      endDate = picked;

      endDateController.text = DateFormatter.short(picked);
    }
  }

  // ------------------------------------------------------------
  // BİTİŞ TARİHİ
  // ------------------------------------------------------------

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? startDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked == null) {
      return;
    }

    endDate = picked;

    endDateController.text = DateFormatter.short(picked);
  }

  // ------------------------------------------------------------
  // DISPOSE
  // ------------------------------------------------------------

  void dispose() {
    descriptionController.dispose();
    startDateController.dispose();
    endDateController.dispose();
  }
}
