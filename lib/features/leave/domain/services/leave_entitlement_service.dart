import '../../../personnel/domain/models/personnel.dart';
import '../models/leave.dart';

/// Personelin yıllık izin hak edişi, kullanım miktarları ve kalan bakiyesini temsil eder.
class LeaveEntitlement {
  /// O takvim yılı için temel hak ediş (1-10 yıl: 24 gün, >10 yıl: 34 gün)
  final int baseAnnualQuota;

  /// Bir önceki takvim yılından (1 Ocak - 31 Aralık) devreden izin gün sayısı
  final int transferredDays;

  /// Cari yıl için kullanılabilir toplam yıllık izin hakkı (baseAnnualQuota + transferredDays)
  final int totalAnnualDays;

  /// Cari yılda kullanılan yıllık izin gün sayısı
  final int usedAnnualDays;

  /// Kalan yıllık izin gün sayısı (totalAnnualDays - usedAnnualDays, en az 0)
  final int remainingAnnualDays;

  /// Cari yılda kullanılan mazeret izni gün sayısı
  final int usedExcuseDays;

  /// Cari yılda kullanılan sağlık raporu gün sayısı
  final int usedReportDays;

  /// Personelin kıdem yılı
  final int seniorityYears;

  /// İznin hesaplandığı takvim yılı (örn: 2026)
  final int targetYear;

  const LeaveEntitlement({
    required this.baseAnnualQuota,
    this.transferredDays = 0,
    required this.totalAnnualDays,
    required this.usedAnnualDays,
    required this.remainingAnnualDays,
    required this.usedExcuseDays,
    required this.usedReportDays,
    required this.seniorityYears,
    required this.targetYear,
  });

  /// Kullanım oranı (0.0 ile 1.0 arası)
  double get usagePercentage =>
      totalAnnualDays > 0 ? (usedAnnualDays / totalAnnualDays).clamp(0.0, 1.0) : 0.0;
}

/// Personel kıdem yılına ve izin kayıtlarına göre hak ediş hesaplayan servis.
///
/// Kurallar:
/// - İzin dönemi: Her yıl 1 Ocak - 31 Aralık arası.
/// - Kıdem < 1 yıl: 0 gün hak ediş.
/// - Kıdem 1-10 yıl (10 yıl dahil): 24 gün yıllık izin hakkı.
/// - Kıdem > 10 yıl: 34 gün yıllık izin hakkı.
/// - Devretme kuralı: Yeni izinlere eğer varsa yalnızca BİR ÖNCEKİ yılın (T - 1) kalan izinleri eklenir.
///   Daha önceki yıllardan (T - 2 ve öncesi) kalan izinler devretmez (yanar).
class LeaveEntitlementService {
  const LeaveEntitlementService();

  /// Personelin işe başlama tarihine göre kıdem yılını hesaplar.
  int calculateSeniorityYears(DateTime startDate, [DateTime? asOfDate]) {
    final target = asOfDate ?? DateTime.now();
    int years = target.year - startDate.year;
    if (target.month < startDate.month ||
        (target.month == startDate.month && target.day < startDate.day)) {
      years--;
    }
    return years < 0 ? 0 : years;
  }

  /// Kullanıcı kuralı:
  /// - 1 yıldan az hizmet süresi -> 0 gün
  /// - 1-10 yıl (10 yılı tamamlamayan personele kadar) -> 24 gün
  /// - 10 yıl ve üzeri (10. yılı tamamlayan personel dahil) -> 34 gün
  int calculateAnnualQuota(int seniorityYears) {
    if (seniorityYears < 1) {
      return 0;
    } else if (seniorityYears < 10) {
      return 24;
    } else {
      return 34;
    }
  }

  /// Bir iznin belirtilen takvim yılı (1 Ocak - 31 Aralık) içine düşen gün sayısını hesaplar.
  int calculateDaysInYear(Leave leave, int year) {
    final yearStart = DateTime(year, 1, 1);
    final yearEnd = DateTime(year, 12, 31);
    final start = DateTime(leave.startDate.year, leave.startDate.month, leave.startDate.day);
    final end = DateTime(leave.endDate.year, leave.endDate.month, leave.endDate.day);

    if (end.isBefore(yearStart) || start.isAfter(yearEnd)) {
      return 0;
    }

    final effectiveStart = start.isBefore(yearStart) ? yearStart : start;
    final effectiveEnd = end.isAfter(yearEnd) ? yearEnd : end;

    return effectiveEnd.difference(effectiveStart).inDays + 1;
  }

  /// Verilen personel ve izin listesi üzerinden hak ediş ve kalan günleri hesaplar.
  LeaveEntitlement calculate({
    required Personnel personnel,
    required List<Leave> leaves,
    int? targetYear,
    DateTime? asOfDate,
    bool enableCarryover = true,
  }) {
    final refDate = asOfDate ?? DateTime.now();
    final year = targetYear ?? refDate.year;

    final seniority = calculateSeniorityYears(personnel.startDate, refDate);
    final baseQuota = calculateAnnualQuota(seniority);

    // ------------------------------------------------------------
    // BİR ÖNCEKİ YILDAN DEVREDEN İZİN (CARRYOVER)
    // Sadece bir önceki yıldan (year - 1) kalan izinler devredebilir.
    // 2 yıl ve öncesinden kalan izinler devretmez.
    // ------------------------------------------------------------
    int transferred = 0;
    if (enableCarryover && personnel.startDate.year < year) {
      final prevYear = year - 1;
      final prevRefDate = DateTime(prevYear, 12, 31);
      final prevSeniority = calculateSeniorityYears(personnel.startDate, prevRefDate);
      final prevBaseQuota = calculateAnnualQuota(prevSeniority);

      if (prevBaseQuota > 0) {
        int usedPrevAnnual = 0;
        for (final l in leaves) {
          if (l.personnelId == personnel.id && l.type == LeaveType.annual) {
            usedPrevAnnual += calculateDaysInYear(l, prevYear);
          }
        }
        final prevRemaining = prevBaseQuota - usedPrevAnnual;
        transferred = prevRemaining > 0
            ? (prevRemaining > prevBaseQuota ? prevBaseQuota : prevRemaining)
            : 0;
      }
    }

    final totalAnnual = baseQuota + transferred;

    // Hedef takvim yılı (1 Ocak - 31 Aralık) içindeki kullanımlar
    int usedAnnual = 0;
    int usedExcuse = 0;
    int usedReport = 0;

    for (final l in leaves) {
      if (l.personnelId == personnel.id) {
        final daysInYear = calculateDaysInYear(l, year);
        if (daysInYear > 0) {
          switch (l.type) {
            case LeaveType.annual:
              usedAnnual += daysInYear;
              break;
            case LeaveType.excuse:
              usedExcuse += daysInYear;
              break;
            case LeaveType.report:
              usedReport += daysInYear;
              break;
          }
        }
      }
    }

    final remaining = (totalAnnual - usedAnnual) < 0 ? 0 : (totalAnnual - usedAnnual);

    return LeaveEntitlement(
      baseAnnualQuota: baseQuota,
      transferredDays: transferred,
      totalAnnualDays: totalAnnual,
      usedAnnualDays: usedAnnual,
      remainingAnnualDays: remaining,
      usedExcuseDays: usedExcuse,
      usedReportDays: usedReport,
      seniorityYears: seniority,
      targetYear: year,
    );
  }
}
