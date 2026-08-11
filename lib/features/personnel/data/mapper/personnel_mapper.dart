import 'package:drift/drift.dart';

import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

extension PersonnelMapper on PersonnelTableData {
  Personnel toDomain() {
    return Personnel(
      id: id,
      registryNumber: registryNumber,
      fullName: fullName,
      rank: rank,
      title: title,
      branch: branch,
      department: department,
      startDate: startDate,
      endDate: endDate,
      phone: phone,
      email: email,
      address: address,
      bloodType: bloodType,
      relativeName: relativeName,
      relativePhone: relativePhone,
      status: PersonnelStatus.values.firstWhere(
        (e) => e.name == status,
        orElse: () => PersonnelStatus.duty,
      ),
      profilePhoto: profilePhoto,
    );
  }
}

extension PersonnelCompanionMapper on Personnel {
  PersonnelTableCompanion toInsertCompanion() {
    return PersonnelTableCompanion.insert(
      registryNumber: registryNumber,
      fullName: fullName,
      rank: rank,
      title: title,
      branch: branch,
      department: department,
      startDate: startDate,
      endDate: Value(endDate),
      phone: phone,
      email: email,
      address: address,
      bloodType: Value(bloodType),
      relativeName: Value(relativeName),
      relativePhone: Value(relativePhone),
      status: Value(status.name),
      profilePhoto: Value(profilePhoto),
    );
  }

  PersonnelTableCompanion toCompanion() {
    return PersonnelTableCompanion(
      id: Value(id!),
      registryNumber: Value(registryNumber),
      fullName: Value(fullName),
      rank: Value(rank),
      title: Value(title),
      branch: Value(branch),
      department: Value(department),
      startDate: Value(startDate),
      endDate: Value(endDate),
      phone: Value(phone),
      email: Value(email),
      address: Value(address),
      bloodType: Value(bloodType),
      relativeName: Value(relativeName),
      relativePhone: Value(relativePhone),
      status: Value(status.name),
      profilePhoto: Value(profilePhoto),
    );
  }
}
