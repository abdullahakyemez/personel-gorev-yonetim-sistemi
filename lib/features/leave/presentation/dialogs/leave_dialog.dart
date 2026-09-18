import 'package:flutter/material.dart';
import 'package:personel_gorev_yonetim_sistemi/core/widgets/dialogs/pgys_dialog.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/domain/models/leave.dart';
import 'package:personel_gorev_yonetim_sistemi/features/leave/presentation/forms/leave_form.dart';

Future<void> showLeaveDialog(
  BuildContext context, {
  Leave? leave,
}) async {
  final isEdit = leave != null;
  await showDialog(
    context: context,
    builder: (_) {
      return PGYSDialog(
        title: isEdit ? 'İzin / Rapor Kaydını Düzenle' : 'Yeni İzin / Rapor Ekle',
        subtitle: isEdit
            ? 'İzin bilgilerini, tarihlerini ve adresini güncelleyin'
            : 'Personel için izin veya sağlık raporu tanımlayın',
        icon: Icons.event_note_outlined,
        scrollable: true,
        child: SizedBox(
          width: 680,
          child: LeaveForm(leave: leave),
        ),
      );
    },
  );
}
