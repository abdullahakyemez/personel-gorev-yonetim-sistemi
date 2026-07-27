import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../domain/models/personnel.dart';

import 'package:personel_gorev_yonetim_sistemi/core/di/service_locator.dart';

import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/usecases/personnel/get_all_personnel_usecase.dart';

final getAllPersonnelUseCaseProvider = Provider<GetAllPersonnelUseCase>((ref) {
  return getIt<GetAllPersonnelUseCase>();
});
final personnelListProvider = FutureProvider<List<Personnel>>((ref) async {
  final useCase = ref.watch(getAllPersonnelUseCaseProvider);
  return useCase();
});

final personnelSearchProvider = StateProvider<String>((ref) => '');

final filteredPersonnelProvider = Provider<AsyncValue<List<Personnel>>>((ref) {
  final personnel = ref.watch(personnelListProvider);

  final search = ref.watch(personnelSearchProvider).toLowerCase();
  final rank = ref.watch(selectedRankProvider);
  final branch = ref.watch(selectedBranchProvider);

  return personnel.whenData((list) {
    var result = list;

    if (search.isNotEmpty) {
      result = result.where((person) {
        return person.fullName.toLowerCase().contains(search.toLowerCase()) ||
            person.registryNumber.contains(search) ||
            person.rank.toLowerCase().contains(search.toLowerCase());
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

    return result;
  });
});

final selectedRankProvider = StateProvider<String?>((ref) => null);
final selectedBranchProvider = StateProvider<String?>((ref) => null);
