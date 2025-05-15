import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];

  List<TaskModel> get openTasks =>
      _tasks.where((task) => task.status != 'Completed').toList();

  int get completedCount =>
      _tasks.where((task) => task.status == 'Completed').length;

  Future<void> loadTasks() async {
    _tasks = await LocalDatabase.getTasks();
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    await LocalDatabase.insertTask(task);
    await loadTasks();
  }
  TaskModel? getActiveTask() {
    try {
      return _tasks.firstWhere((task) => task.status == 'In Progress');
    } catch (_) {
      return null;
    }
  }
  void updateTaskStatus(String taskId, String newStatus) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex];
    }
  }

  void updateTaskEndTime(String taskId, String newEndTime) {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex];
      notifyListeners();
    }
  }
}

