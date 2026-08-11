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
    // GÖREVDEN AYRILMIŞ PERSONEL
    // ============================================================

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
    // PERSONELİN BUGÜNKÜ İZİN / RAPOR KAYITLARI
    // ============================================================

    final personnelLeaves = leaves.where(
      (leave) =>
          leave.personnelId == personnel.registryNumber &&
          _isDateBetween(day, leave.startDate, leave.endDate),
    );

    // ============================================================
    // 1. ÖNCELİK → RAPOR
    // ============================================================

    if (personnelLeaves.any((leave) => leave.type == LeaveType.report)) {
      return PersonnelStatus.sickReport;
    }

    // ============================================================
    // 2. ÖNCELİK → İZİN
    // ============================================================

    if (personnelLeaves.any(
      (leave) =>
          leave.type == LeaveType.annual || leave.type == LeaveType.excuse,
    )) {
      return PersonnelStatus.leave;
    }

    // ============================================================
    // 3. ÖNCELİK → ÇALIŞMA DÜZENİ
    // ============================================================

    final schedule = personnel.workSchedule;

    if (schedule != null) {
      if (schedule.isDutyDay(day)) {
        return PersonnelStatus.duty;
      }

      return PersonnelStatus.resting;
    }

    // ============================================================
    // 4. ÇALIŞMA DÜZENİ YOKSA MEVCUT DURUM
    // ============================================================

    return personnel.status;
  }

  static bool _isDateBetween(DateTime date, DateTime start, DateTime end) {
    final startDay = DateTime(start.year, start.month, start.day);

    final endDay = DateTime(end.year, end.month, end.day);

    return !date.isBefore(startDay) && !date.isAfter(endDay);
  }
}
