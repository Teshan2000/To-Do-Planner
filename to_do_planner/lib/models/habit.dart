import 'package:to_do_planner/models/category.dart';

class Habit {
  final String title;
  final DateTime startDate;
  final Category? category;
  final List<DateTime> completion;
  final int streak;
  final String? reminder;
  bool isCompleted;

  Habit({
    required this.title,
    required this.startDate,
    required this.category,
    this.completion = const [],
    this.streak = 0,
    this.reminder,
    this.isCompleted = false,
  });

  bool isCompletedToday() {
    final now = DateTime.now();
    return completion.any(
        (d) => d.year == now.year && d.month == now.month && d.day == now.day);
  }

  int getStreak() {
    List<DateTime> sorted = [...completion]..sort((a, b) => b.compareTo(a));
    int streak = 0;
    DateTime day = DateTime.now();

    for (final date in sorted) {
      if (date.year == day.year &&
          date.month == day.month &&
          date.day == day.day) {
        streak++;
        day = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }
}
