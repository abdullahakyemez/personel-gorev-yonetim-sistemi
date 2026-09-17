import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../leave/application/leave_provider.dart';
import '../../personnel/application/personnel_provider.dart';
import '../../personnel/constants/personnel_lookup.dart';
import '../../personnel/domain/models/personnel.dart';
import '../../personnel/domain/services/personnel_status_resolver.dart';
import '../domain/models/today_roster.dart';

final todayRosterProvider = Provider<AsyncValue<TodayRoster>>((ref) {
  final personnelAsync = ref.watch(scopedPersonnelProvider);
  final leaveAsync = ref.watch(scopedLeaveProvider);

  if (personnelAsync.isLoading || leaveAsync.isLoading) {
    return const AsyncLoading();
  }

  if (personnelAsync.hasError) {
    return AsyncError(personnelAsync.error!, personnelAsync.stackTrace!);
  }

  if (leaveAsync.hasError) {
    return AsyncError(leaveAsync.error!, leaveAsync.stackTrace!);
  }

  final personnel = List<Personnel>.from(personnelAsync.value!);
  final leaves = leaveAsync.value!;
  final now = DateTime.now();

  personnel.sort((a, b) {
    final rankA = PersonnelLookup.ranks.indexOf(a.rank);
    final rankB = PersonnelLookup.ranks.indexOf(b.rank);
    if (rankA != rankB) return rankA.compareTo(rankB);
    return a.fullName.compareTo(b.fullName);
  });

  final duty = <Personnel>[];
  final resting = <Personnel>[];
  final leave = <Personnel>[];
  final sickReport = <Personnel>[];

  for (final person in personnel) {
    final status = PersonnelStatusResolver.resolve(
      personnel: person,
      leaves: leaves,
      date: now,
    );

    switch (status) {
      case PersonnelStatus.duty:
        duty.add(person);
      case PersonnelStatus.resting:
        resting.add(person);
      case PersonnelStatus.leave:
        leave.add(person);
      case PersonnelStatus.sickReport:
        sickReport.add(person);
    }
  }

  return AsyncData(
    TodayRoster(
      duty: duty,
      resting: resting,
      leave: leave,
      sickReport: sickReport,
    ),
  );
});
