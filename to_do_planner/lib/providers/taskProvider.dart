import 'package:flutter/foundation.dart';
import 'package:to_do_planner/models/task.dart';

class TaskProvider with ChangeNotifier {
  final List<Task> _tasks = [];
  final List<Task> _completedTasks = [];

  List<Task> get tasks => _tasks;
  List<Task> get completedTasks => _completedTasks;

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

  void completeTask(Task task) {
    task.isCompleted = !task.isCompleted;
    if (task.isCompleted) {
      task.isCompleted = true;
      tasks.remove(task);
      _completedTasks.add(task);
    } else {
      task.isCompleted = false;
      _completedTasks.remove(task);
      tasks.add(task);
    }
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  List<Task> getTasksByDate(DateTime date) {
    return _tasks.where((task) {
      return task.date.year == date.year &&
          task.date.month == date.month &&
          task.date.day == date.day;
    }).toList();
  }
}
