import 'package:flutter/foundation.dart';
import 'package:to_do_planner/models/habit.dart';

class HabitProvider with ChangeNotifier {
  final List<Habit> _habits = [];
  final List<Habit> _completedHabits = [];

  List<Habit> get habits => _habits;
  List<Habit> get completedHabits => _completedHabits;

  void addHabit(Habit habit) {
    _habits.add(habit);
    notifyListeners();
  } 

  void updateHabit(Habit oldHabit, Habit newHabit) {
    int index = _habits.indexOf(oldHabit);
    if (index != -1) {
      _habits[index] = newHabit;
      notifyListeners();
    }
  }

  void completeHabit(Habit habit) {
    // habit.isCompleted = !habit.isCompleted;
    // if (habit.isCompleted) {
    //   habit.isCompleted = true;
    //   habits.remove(habit);
    //   _completedHabits.add(habit);
    // } else {
    //   habit.isCompleted = false;
    //   _completedHabits.remove(habit);
    //   habits.add(habit);
    // }

    final today = DateTime.now();
    final dateExists = habit.completion.any((d) =>
        d.year == today.year && d.month == today.month && d.day == today.day);

    if (dateExists) {
      habit.completion.removeWhere((d) =>
          d.year == today.year && d.month == today.month && d.day == today.day);
    } else {
      habit.completion.add(today);
    }

    notifyListeners();
  }

  void removeHabit(Habit habit) {
    _habits.remove(habit);
    notifyListeners();
  }

  List<Habit> getHabitsByDate(DateTime date) {
    return _habits.where((habit) =>
      habit.startDate.year == date.year &&
      habit.startDate.month == date.month &&
      habit.startDate.day == date.day
    ).toList();
  }
}
