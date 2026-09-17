import 'package:flutter/material.dart';

import '../models/personnel.dart';

extension PersonnelStatusExtension on PersonnelStatus {
  String get label {
    switch (this) {
      case PersonnelStatus.duty:
        return 'Görevde';
      case PersonnelStatus.resting:
        return 'İstirahatli';
      case PersonnelStatus.leave:
        return 'İzinli';
      case PersonnelStatus.sickReport:
        return 'Raporlu';
    }
  }

  Color get color {
    switch (this) {
      case PersonnelStatus.duty:
        return Colors.green;
      case PersonnelStatus.resting:
        return Colors.orange;
      case PersonnelStatus.leave:
        return Colors.blue;
      case PersonnelStatus.sickReport:
        return Colors.red;
    }
  }
}
