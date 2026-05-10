import 'package:get/get.dart';

import '../db/database_helper.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  final DatabaseHelper _db = DatabaseHelper.instance;

  final tasks = <Task>[].obs;
  final doneCount = 0.obs;
  final pendingCount = 0.obs;
  final perDay = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    refreshAll();
  }

  Future<void> refreshAll() async {
    tasks.value = await _db.getAllTasks();
    doneCount.value = await _db.countDone();
    pendingCount.value = await _db.countPending();
    perDay.value = await _db.donePerDay(days: 7);
  }

  Future<void> addTask({
    required String title,
    required String description,
    required DateTime dueDate,
    required TaskCategory category,
  }) async {
    await _db.insertTask(Task(
      title: title.trim(),
      description: description.trim(),
      dueDate: dueDate,
      category: category,
    ));
    await refreshAll();
  }

  Future<void> toggleDone(Task t) async {
    final next = t.copyWith(
      done: !t.done,
      completedAt: !t.done ? DateTime.now() : null,
    );
    await _db.updateTask(next);
    await refreshAll();
  }

  Future<void> remove(int id) async {
    await _db.deleteTask(id);
    await refreshAll();
  }
}
