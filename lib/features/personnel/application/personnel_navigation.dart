import '../domain/models/personnel.dart';

extension PersonnelNavigation on List<Personnel> {
  int indexOfId(int? id) {
    if (id == null) return -1;

    return indexWhere((e) => e.id == id);
  }

  Personnel? next(int? id) {
    final index = indexOfId(id);

    if (index == -1) {
      return isEmpty ? null : first;
    }

    if (index >= length - 1) {
      return last;
    }

    return this[index + 1];
  }

  Personnel? previous(int? id) {
    final index = indexOfId(id);

    if (index <= 0) {
      return isEmpty ? null : first;
    }

    return this[index - 1];
  }
}
