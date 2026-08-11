import '../../domain/models/leave.dart';
import '../../domain/repositories/leave_repository.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  final List<Leave> _leaves = [];

  @override
  Future<List<Leave>> getAll() async {
    return List.unmodifiable(_leaves);
  }

  @override
  Future<List<Leave>> getByPersonnel(String personnelId) async {
    return _leaves.where((leave) => leave.personnelId == personnelId).toList();
  }

  @override
  Future<void> add(Leave leave) async {
    _leaves.add(leave);
  }

  @override
  Future<void> update(Leave leave) async {
    final index = _leaves.indexWhere((e) => e.id == leave.id);

    if (index != -1) {
      _leaves[index] = leave;
    }
  }

  @override
  Future<void> delete(String id) async {
    _leaves.removeWhere((leave) => leave.id == id);
  }
}
