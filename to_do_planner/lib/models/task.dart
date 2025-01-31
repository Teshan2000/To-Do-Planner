import 'package:to_do_planner/models/category.dart';

class Task {
  final String title;
  final Category? category;
  final DateTime date;
  final String time;
  final String? reminder;
  final String? repeat;
  bool isCompleted;

  Task({
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    this.reminder,
    this.repeat,
    this.isCompleted = false, 
  });
}
