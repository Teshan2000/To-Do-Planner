import 'package:flutter/foundation.dart';
import 'package:to_do_planner/models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task oldTask, Task newTask) {
    int index = _tasks.indexOf(oldTask);
    if (index != -1) {
      _tasks[index] = newTask;
      notifyListeners();
    }
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}
