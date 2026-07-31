import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PersonnelSortField { registry, fullName, rank, branch }

enum SortDirection { ascending, descending }

class PersonnelSortState {
  final PersonnelSortField? field;
  final SortDirection direction;

  const PersonnelSortState({
    this.field,
    this.direction = SortDirection.ascending,
  });

  PersonnelSortState copyWith({
    PersonnelSortField? field,
    SortDirection? direction,
  }) {
    return PersonnelSortState(
      field: field ?? this.field,
      direction: direction ?? this.direction,
    );
  }
}

final personnelSortProvider =
    NotifierProvider<PersonnelSortNotifier, PersonnelSortState>(
      PersonnelSortNotifier.new,
    );

class PersonnelSortNotifier extends Notifier<PersonnelSortState> {
  @override
  PersonnelSortState build() => const PersonnelSortState();

  void toggle(PersonnelSortField newField) {
    // tüm geçiş mantığı burada

    final current = state;

    // Başka sütuna tıklandıysa
    if (current.field != newField) {
      state = PersonnelSortState(
        field: newField,
        direction: SortDirection.ascending,
      );
      return;
    }

    // Aynı sütuna tekrar tıklandıysa

    if (current.direction == SortDirection.ascending) {
      state = current.copyWith(direction: SortDirection.descending);
      return;
    }

    // Üçüncü tıklama
    state = const PersonnelSortState();
  }
}
