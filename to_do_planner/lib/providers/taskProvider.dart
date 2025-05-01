import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:to_do_planner/models/task.dart';

class TaskProvider with ChangeNotifier {
  final Box<Task> _taskBox = Hive.box<Task>('tasks');

  List<Task> get tasks =>
      _taskBox.values.where((task) => !task.isCompleted).toList();

  List<Task> get completedTasks =>
      _taskBox.values.where((task) => task.isCompleted).toList();

  void addTask(Task task) {
    _taskBox.add(task);
    notifyListeners();
  }

  void updateTask(Task oldTask, Task newTask) {
    int key = oldTask.key;
    _taskBox.put(key, newTask);
    notifyListeners();
  }

  void completeTask(Task task) {
    task.isCompleted = !task.isCompleted;
    task.save();
    notifyListeners();
  }

  void removeTask(Task task) {
    task.delete();
    notifyListeners();
  }

  List<Task> getTasksByDate(DateTime selectedDate) {
    return tasks.where((task) {
      return task.date.year == selectedDate.year &&
            task.date.month == selectedDate.month &&
            task.date.day == selectedDate.day;
    }).toList();
  }

}





// class TaskProvider with ChangeNotifier {
//   final List<Task> _tasks = [];
//   final List<Task> _completedTasks = [];

//   List<Task> get tasks => _tasks;
//   List<Task> get completedTasks => _completedTasks;

//   void addTask(Task task) {
//     _tasks.add(task);
//     notifyListeners();
//   }

//   void updateTask(Task oldTask, Task newTask) {
//     int index = _tasks.indexOf(oldTask);
//     if (index != -1) {
//       _tasks[index] = newTask;
//       notifyListeners();
//     }
//   }

//   void completeTask(Task task) {
//     task.isCompleted = !task.isCompleted;
//     if (task.isCompleted) {
//       task.isCompleted = true;
//       tasks.remove(task);
//       _completedTasks.add(task);
//     } else {
//       task.isCompleted = false;
//       _completedTasks.remove(task);
//       tasks.add(task);
//     }
//     notifyListeners();
//   }

//   void removeTask(Task task) {
//     _tasks.remove(task);
//     notifyListeners();
//   }

//   List<Task> getTasksByDate(DateTime date) {
//     return _tasks.where((task) {
//       return task.date.year == date.year &&
//           task.date.month == date.month &&
//           task.date.day == date.day;
//     }).toList();
//   }
// }
