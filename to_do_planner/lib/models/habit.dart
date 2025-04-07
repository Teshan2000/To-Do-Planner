import 'package:to_do_planner/models/category.dart';

class Habit {
  final String title;
  final String time;
  final Category? category;
  final List<bool> completion;
  final int streak;
  bool isCompleted;
  String? reminder;

  Habit( {
    required this.title, 
    required this.time, 
    required this.category, 
    required this.completion, 
    this.streak = 0,
    this.isCompleted = false,
    this.reminder,
  });

  // Map<String, dynamic> toJson() => {
  //   'title': title,
  //   'time': time,
  //   'category': category,
  //   'completion': completion,
  //   'streak': streak,
  //   'isCompleted': isCompleted,
  //   'reminder': reminder,
  // };

  // factory Habit.fromJson(Map<String, dynamic> json) => Habit(
  //   title: json['title'], 
  //   time: json['title'], 
  //   category: json['title'],    
  //   completion: List<bool>.from(json['completion']),
  //   streak: json['streak'], 
  //   isCompleted: json['isCompleted'], 
  //   reminder: json['reminder'], 
  // );
}
