import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../domain/models/personnel.dart';
import 'personnel_sort_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';
import '../constants/personnel_lookup.dart';

import 'package:personel_gorev_yonetim_sistemi/features/auth/application/data_scope_provider.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/get_all_personnel_usecase.dart';

final getAllPersonnelUseCaseProvider = Provider<GetAllPersonnelUseCase>((ref) {
  return getIt<GetAllPersonnelUseCase>();
});
final personnelListProvider = FutureProvider<List<Personnel>>((ref) async {
  final useCase = ref.watch(getAllPersonnelUseCaseProvider);
  return useCase();
});

final personnelSearchProvider = StateProvider<String>((ref) => '');

final scopedPersonnelProvider = Provider<AsyncValue<List<Personnel>>>((ref) {
  final personnel = ref.watch(personnelListProvider);
  final scopeFilter = ref.watch(dataScopeFilterProvider);

  return personnel.whenData(
    (list) => list.where((person) => scopeFilter.filterPersonnel(person)).toList(),
  );
});

final filteredPersonnelProvider = Provider<AsyncValue<List<Personnel>>>((ref) {
  final scoped = ref.watch(scopedPersonnelProvider);

  final search = ref.watch(personnelSearchProvider).toLowerCase();
  final rank = ref.watch(selectedRankProvider);
  final branch = ref.watch(selectedBranchProvider);

  final sort = ref.watch(personnelSortProvider);

  return scoped.whenData((list) {
    var result = List<Personnel>.from(list);

    if (search.isNotEmpty) {
      result = result.where((person) {
        return person.fullName.toLowerCase().contains(search) ||
            person.registryNumber.contains(search) ||
            person.rank.toLowerCase().contains(search);
      }).toList();
    }
    if (rank != null) {
      result = result.where((person) {
        return person.rank == rank;
      }).toList();
    }
    if (branch != null) {
      result = result.where((person) {
        return person.branch.toLowerCase().contains(branch.toLowerCase());
      }).toList();
    }

    /*result.sort((a, b) {
      final rankA = PersonnelLookup.ranks.indexOf(a.rank);
      final rankB = PersonnelLookup.ranks.indexOf(b.rank);
      if (rankA != rankB) {
        return rankA.compareTo(rankB);
      }

      final registryA = int.tryParse(a.registryNumber) ?? 0;
      final registryB = int.tryParse(b.registryNumber) ?? 0;

      return registryA.compareTo(registryB);
    });*/

    if (sort.field != null) {
      result.sort((a, b) {
        int comparison = 0;

        switch (sort.field!) {
          case PersonnelSortField.registry:
            final regA = int.tryParse(a.registryNumber) ?? 0;
            final regB = int.tryParse(b.registryNumber) ?? 0;
            comparison = regA.compareTo(regB);
            break;
          case PersonnelSortField.fullName:
            comparison = a.fullName.compareTo(b.fullName);
            break;
          case PersonnelSortField.rank:
            final rankA = PersonnelLookup.ranks.indexOf(a.rank);
            final rankB = PersonnelLookup.ranks.indexOf(b.rank);
            comparison = rankA.compareTo(rankB);
            break;

          case PersonnelSortField.branch:
            comparison = a.branch.compareTo(b.branch);
            break;
        }
        return sort.direction == SortDirection.ascending
            ? comparison
            : -comparison;
      });
    } else {
      result.sort((a, b) {
        final rankA = PersonnelLookup.ranks.indexOf(a.rank);
        final rankB = PersonnelLookup.ranks.indexOf(b.rank);
        if (rankA != rankB) {
          return rankA.compareTo(rankB);
        }

        final registryA = int.tryParse(a.registryNumber) ?? 0;
        final registryB = int.tryParse(b.registryNumber) ?? 0;

        return registryA.compareTo(registryB);
      });
    }

    return result;
  });
});

final selectedRankProvider = StateProvider<String?>((ref) => null);
final selectedBranchProvider = StateProvider<String?>((ref) => null);
