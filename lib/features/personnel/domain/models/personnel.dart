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
  final DateTime? officeStartDate;
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
    this.officeStartDate,
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

  Personnel copyWith({
    int? id,
    String? registryNumber,
    String? fullName,
    String? rank,
    String? title,
    String? branch,
    String? department,
    DateTime? startDate,
    DateTime? officeStartDate,
    DateTime? endDate,
    String? phone,
    String? email,
    String? address,
    String? bloodType,
    String? relativeName,
    String? relativePhone,
    PersonnelStatus? status,
    String? profilePhoto,
    WorkSchedule? workSchedule,
  }) {
    return Personnel(
      id: id ?? this.id,
      registryNumber: registryNumber ?? this.registryNumber,
      fullName: fullName ?? this.fullName,
      rank: rank ?? this.rank,
      title: title ?? this.title,
      branch: branch ?? this.branch,
      department: department ?? this.department,
      startDate: startDate ?? this.startDate,
      officeStartDate: officeStartDate ?? this.officeStartDate,
      endDate: endDate ?? this.endDate,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      bloodType: bloodType ?? this.bloodType,
      relativeName: relativeName ?? this.relativeName,
      relativePhone: relativePhone ?? this.relativePhone,
      status: status ?? this.status,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      workSchedule: workSchedule ?? this.workSchedule,
    );
  }
}
