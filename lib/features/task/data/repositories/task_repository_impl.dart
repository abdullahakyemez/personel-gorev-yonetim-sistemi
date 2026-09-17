import 'package:personel_gorev_yonetim_sistemi/core/database/app_database.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/models/personnel_history.dart';
import 'package:personel_gorev_yonetim_sistemi/features/personnel/domain/repositories/personnel_history_repository.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/extensions/task_status_extension.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/models/task.dart';
import 'package:personel_gorev_yonetim_sistemi/features/task/domain/repositories/task_repository.dart';

import '../mapper/task_mapper.dart';

class TaskRepositoryImpl implements TaskRepository {
  final AppDatabase database;
  final PersonnelHistoryRepository historyRepository;

  TaskRepositoryImpl(this.database, this.historyRepository);

  @override
  Future<List<Task>> getAll() async {
    final taskRows = await database.select(database.taskTable).get();
    final assignments = await database.select(database.taskPersonnelTable).get();

    final assignmentsByTask = <String, List<TaskPersonnelTableData>>{};
    for (final assignment in assignments) {
      assignmentsByTask.putIfAbsent(assignment.taskId, () => []).add(assignment);
    }

    return taskRows
        .map(
          (task) => TaskMapper.toDomain(
            task: task,
            assignments: assignmentsByTask[task.id] ?? [],
          ),
        )
        .toList();
  }

  @override
  Future<Task?> getById(String id) async {
    final task = await (database.select(database.taskTable)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();

    if (task == null) return null;

    final assignments = await (database.select(database.taskPersonnelTable)
          ..where((table) => table.taskId.equals(id)))
        .get();

    return TaskMapper.toDomain(task: task, assignments: assignments);
  }

  @override
  Future<List<Task>> getByPersonnel(int personnelId) async {
    final assignments = await (database.select(database.taskPersonnelTable)
          ..where((table) => table.personnelId.equals(personnelId)))
        .get();

    final taskIds = assignments.map((item) => item.taskId).toSet();
    if (taskIds.isEmpty) return [];

    final allTasks = await getAll();
    return allTasks
        .where((task) => task.id != null && taskIds.contains(task.id))
        .toList();
  }

  @override
  Future<void> add(Task task) async {
    final taskId = task.id ?? DateTime.now().microsecondsSinceEpoch.toString();
    final taskToSave = task.id == null ? task.copyWith(id: taskId) : task;

    await database.transaction(() async {
      await database
          .into(database.taskTable)
          .insert(TaskMapper.toTaskCompanion(taskToSave));

      for (final personnelId in taskToSave.personnelIds.toSet()) {
        await database
            .into(database.taskPersonnelTable)
            .insert(
              TaskMapper.toPersonnelCompanion(
                taskId: taskId,
                personnelId: personnelId,
              ),
            );

        await historyRepository.add(
          personnelId: personnelId,
          action: PersonnelHistoryAction.taskAdded,
          description:
              'Görev eklendi: ${taskToSave.title} (${_date(taskToSave.startDate)} - ${_date(taskToSave.endDate)}).',
        );
      }
    });
  }

  @override
  Future<void> update(Task task) async {
    if (task.id == null) {
      throw ArgumentError('Güncellenecek görevin id değeri olmalıdır.');
    }

    await database.transaction(() async {
      final oldTask = await getById(task.id!);
      if (oldTask == null) {
        throw StateError('Güncellenecek görev bulunamadı: ${task.id}');
      }

      await (database.update(database.taskTable)
            ..where((table) => table.id.equals(task.id!)))
          .write(TaskMapper.toTaskCompanion(task));

      final oldPersonnel = oldTask.personnelIds.toSet();
      final newPersonnel = task.personnelIds.toSet();

      await (database.delete(database.taskPersonnelTable)
            ..where((table) => table.taskId.equals(task.id!)))
          .go();

      for (final personnelId in newPersonnel) {
        await database
            .into(database.taskPersonnelTable)
            .insert(
              TaskMapper.toPersonnelCompanion(
                taskId: task.id!,
                personnelId: personnelId,
              ),
            );
      }

      final statusChanged = oldTask.status != task.status;
      final statusSuffix = statusChanged
          ? ' (Durum: ${oldTask.status.label} -> ${task.status.label})'
          : '';

      for (final personnelId in newPersonnel) {
        if (!oldPersonnel.contains(personnelId)) {
          await historyRepository.add(
            personnelId: personnelId,
            action: PersonnelHistoryAction.taskAssigned,
            description:
                'Görev personele atandı: ${task.title} (${_date(task.startDate)} - ${_date(task.endDate)}).',
          );
        } else {
          await historyRepository.add(
            personnelId: personnelId,
            action: PersonnelHistoryAction.taskUpdated,
            description: 'Görev güncellendi: ${task.title}$statusSuffix.',
          );
        }
      }

      for (final personnelId in oldPersonnel.difference(newPersonnel)) {
        await historyRepository.add(
          personnelId: personnelId,
          action: PersonnelHistoryAction.taskUnassigned,
          description: 'Görev personelden kaldırıldı: ${task.title}.',
        );
      }
    });
  }

  @override
  Future<void> delete(String id) async {
    await database.transaction(() async {
      final task = await getById(id);
      if (task == null) return;

      await (database.delete(database.taskTable)
            ..where((table) => table.id.equals(id)))
          .go();

      for (final personnelId in task.personnelIds.toSet()) {
        await historyRepository.add(
          personnelId: personnelId,
          action: PersonnelHistoryAction.taskDeleted,
          description: 'Görev silindi: ${task.title}.',
        );
      }
    });
  }

  @override
  Future<void> importInitialData(List<Task> tasks) async {
    final existingTasks = await database.select(database.taskTable).get();
    if (existingTasks.isNotEmpty || tasks.isEmpty) return;

    await database.transaction(() async {
      for (final task in tasks) {
        final id = task.id ?? DateTime.now().microsecondsSinceEpoch.toString();
        final taskToSave = task.copyWith(id: id);

        await database
            .into(database.taskTable)
            .insert(TaskMapper.toTaskCompanion(taskToSave));

        for (final personnelId in taskToSave.personnelIds.toSet()) {
          await database
              .into(database.taskPersonnelTable)
              .insert(
                TaskMapper.toPersonnelCompanion(
                  taskId: id,
                  personnelId: personnelId,
                ),
              );
        }
      }
    });
  }

  String _date(DateTime value) {
    return '${value.day.toString().padLeft(2, '0')}.${value.month.toString().padLeft(2, '0')}.${value.year}';
  }
}
