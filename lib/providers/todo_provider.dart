import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';

class TodoProvider extends ChangeNotifier {
  final List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  final TextEditingController taskController = TextEditingController();
  final GlobalKey<FormState> addFormKey = GlobalKey<FormState>();

  void addTask() {
    if (!addFormKey.currentState!.validate()) return;

    _tasks.add(
      Task(id: DateTime.now().toString(), title: taskController.text.trim()),
    );

    taskController.clear();
    notifyListeners();
  }

  void toggleTask(String id) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.isCompleted = !task.isCompleted;
    notifyListeners();
  }

  void editTask(String id, String newTitle) {
    final task = _tasks.firstWhere((t) => t.id == id);
    task.title = newTitle;
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  @override
  void dispose() {
    taskController.dispose();
    super.dispose();
  }
}
