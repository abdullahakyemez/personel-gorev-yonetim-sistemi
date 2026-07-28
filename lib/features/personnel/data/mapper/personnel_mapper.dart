import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel.dart';

import 'package:drift/drift.dart';

extension PersonnelMapper on PersonnelTableData {
  Personnel toDomain() {
    return Personnel(
      id: id,
      registryNumber: registryNumber,
      fullName: fullName,
      rank: rank,
      department: department,
      branch: branch,
      phone: phone,
      onDuty: onDuty,
    );
  }
}

extension PersonnelCompanionMapper on Personnel {
  PersonnelTableCompanion toInsertCompanion() {
    return PersonnelTableCompanion.insert(
      registryNumber: registryNumber,
      fullName: fullName,
      phone: phone,
      rank: rank,
      department: department,
      branch: branch,
      onDuty: Value(onDuty),

      email: const Value(null),
      tcIdentity: const Value(null),
      title: const Value(null),
      profilePhoto: const Value(null),
    );
  }

  PersonnelTableCompanion toCompanion() {
    return PersonnelTableCompanion(
      id: Value(id!), // <<< EN ÖNEMLİ SATIR

      registryNumber: Value(registryNumber),
      fullName: Value(fullName),
      phone: Value(phone),
      rank: Value(rank),
      department: Value(department),
      branch: Value(branch),
      onDuty: Value(onDuty),

      email: Value(email),
      tcIdentity: Value(tcIdentity),
      title: Value(title),
      profilePhoto: Value(profilePhoto),
    );
  }
}
