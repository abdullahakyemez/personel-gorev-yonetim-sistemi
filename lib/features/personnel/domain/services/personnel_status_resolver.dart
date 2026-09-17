import '../models/personnel.dart';
import '../../../leave/domain/models/leave.dart';

class PersonnelStatusResolver {
  static PersonnelStatus resolve({
    required Personnel personnel,
    required List<Leave> leaves,
    DateTime? date,
  }) {
    final targetDate = date ?? DateTime.now();

    final day = DateTime(targetDate.year, targetDate.month, targetDate.day);

    // ============================================================
    // 1. GÖREVDEN AYRILMIŞ VEYA HENÜZ BAŞLAMAMIŞ PERSONEL
    // ============================================================

    final startDay = DateTime(
      personnel.startDate.year,
      personnel.startDate.month,
      personnel.startDate.day,
    );

    if (day.isBefore(startDay)) {
      return personnel.status;
    }

    if (personnel.endDate != null) {
      final endDay = DateTime(
        personnel.endDate!.year,
        personnel.endDate!.month,
        personnel.endDate!.day,
      );

      if (day.isAfter(endDay)) {
        return personnel.status;
      }
    }

    // ============================================================
    // PERSONELİN HEDEF TARİHTEKİ İZİN / RAPOR KAYITLARI
    // ============================================================

    final personnelLeaves = leaves.where(
      (leave) =>
          personnel.id != null &&
          leave.personnelId == personnel.id &&
          _isDateBetween(day, leave.startDate, leave.endDate),
    );

    // ============================================================
    // 2. ÖNCELİK → RAPOR
    // ============================================================

    if (personnelLeaves.any((leave) => leave.type == LeaveType.report)) {
      return PersonnelStatus.sickReport;
    }

    // ============================================================
    // 3. ÖNCELİK → İZİN
    // ============================================================

    if (personnelLeaves.any(
      (leave) =>
          leave.type == LeaveType.annual || leave.type == LeaveType.excuse,
    )) {
      return PersonnelStatus.leave;
    }

    // ============================================================
    // 4. ÖNCELİK → ÇALIŞMA DÜZENİ
    // ============================================================

    final schedule = personnel.workSchedule;

    if (schedule != null) {
      if (schedule.isDutyDay(day)) {
        return PersonnelStatus.duty;
      }

      if (schedule.isRestDay(day)) {
        return PersonnelStatus.resting;
      }

      return personnel.status;
    }

    // ============================================================
    // 5. ÇALIŞMA DÜZENİ YOKSA MEVCUT DURUM
    // ============================================================

    return personnel.status;
  }

  static bool _isDateBetween(DateTime date, DateTime start, DateTime end) {
    final startDay = DateTime(start.year, start.month, start.day);

    final endDay = DateTime(end.year, end.month, end.day);

    return !date.isBefore(startDay) && !date.isAfter(endDay);
  }
}
