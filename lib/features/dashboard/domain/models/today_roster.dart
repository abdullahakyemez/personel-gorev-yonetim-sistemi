import '../../../personnel/domain/models/personnel.dart';

class TodayRoster {
  final List<Personnel> duty;
  final List<Personnel> resting;
  final List<Personnel> leave;
  final List<Personnel> sickReport;

  const TodayRoster({
    required this.duty,
    required this.resting,
    required this.leave,
    required this.sickReport,
  });
}
