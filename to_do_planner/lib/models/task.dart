import 'package:to_do_planner/models/category.dart';

class Task {
  final String title;
  final Category category;
  final String date;
  final String time;
  final String reminder;

  Task({
    required this.title,
    required this.category,
    required this.date,
    required this.time,
    required this.reminder,
  });
}
