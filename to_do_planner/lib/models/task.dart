import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_planner/models/category.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late Category? category;

  @HiveField(2)
  late DateTime date;  

  @HiveField(3)
  late String time;

  @HiveField(4)
  late String? reminder;

  @HiveField(5)
  late String? repeat;

  @HiveField(6)
  late bool isCompleted;

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