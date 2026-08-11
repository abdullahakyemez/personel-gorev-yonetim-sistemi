import 'work_schedule.dart';

enum PersonnelStatus { duty, resting, leave, sickReport }

class Personnel {
  final int? id;

  // Genel Bilgiler
  final String registryNumber;
  final String fullName;
  final String rank;
  final String title;

  // Kurum Bilgileri
  final String branch;
  final String department;
  final DateTime startDate;
  final DateTime? endDate;

  // İletişim
  final String phone;
  final String email;
  final String address;

  // Ek Bilgiler
  final String? bloodType;
  final String? relativeName;
  final String? relativePhone;

  // Şimdilik geçiş uyumluluğu için tutuyoruz.
  // Bir sonraki adımda günlük durum sistemine taşıyacağız.
  final PersonnelStatus status;

  final String? profilePhoto;

  //Çalışma düzeni
  final WorkSchedule? workSchedule;

  const Personnel({
    required this.id,
    required this.registryNumber,
    required this.fullName,
    required this.rank,
    required this.title,
    required this.branch,
    required this.department,
    required this.startDate,
    this.endDate,
    required this.phone,
    required this.email,
    required this.address,
    this.bloodType,
    this.relativeName,
    this.relativePhone,
    required this.status,
    this.profilePhoto,
    this.workSchedule,
  });
}
