import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/providers/habitProvider.dart';
import 'package:to_do_planner/screens/editTasks.dart';

class TodayHabitsList extends StatefulWidget {
  final DateTime selectedDate;
  const TodayHabitsList({required this.selectedDate, super.key});

  @override
  State<TodayHabitsList> createState() => _TodayHabitsListState();
}

class _TodayHabitsListState extends State<TodayHabitsList> {
  bool isCompleted = false;
  String formatHabitDate(DateTime habitDate) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));

    if (habitDate.isAtSameMomentAs(today)) {
      return "Today";
    } else if (habitDate.isAtSameMomentAs(tomorrow)) {
      return "Tomorrow";
    } else {
      return DateFormat("dd-MM-yyyy").format(habitDate);
    }
  }
  
  @override
  Widget build(BuildContext context) {    
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, _) {
        final todayHabits = HabitProvider().getHabitsByDate(widget.selectedDate);
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todayHabits.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 5, color: Colors.white),
          itemBuilder: (context, index) {
            final habit = todayHabits[index];
            return Dismissible(
              key: Key(index.toString()),
              background: Container(
                color: const Color.fromARGB(255, 103, 153, 239),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.edit, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: const Color.fromARGB(255, 103, 153, 239),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              confirmDismiss: (DismissDirection direction) async {
                if (direction == DismissDirection.endToStart) {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor:
                              const Color.fromARGB(255, 15, 79, 189),
                          title: Text(
                            "Delete ${habit.title} ?",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                habitProvider.removeHabit(habit);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Delete",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                } else {
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //     builder: (context) => Edittasks(habit: habit)));
                }
              },
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  habitProvider.removeHabit(habit);
                }
              },
              child: ListTile(
                leading: SizedBox(
                  width: 25,
                  child: Checkbox(
                      shape: const CircleBorder(side: BorderSide(width: 1.0)),
                      value: habit.isCompleted,
                      onChanged: (value) {
                        setState(() {
                          habitProvider.completeHabit(habit, DateTime.now());
                          isCompleted = true;
                        });
                      }),
                ),
                title: Text(
                  habit.title,
                  style: TextStyle(
                    color: habit.isCompleted ? Colors.grey : Colors.white,
                    fontSize: 18,
                    decoration: habit.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Text(
                  "${formatHabitDate(habit.startDate)}, ${habit.title}",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 103, 153, 239)),
                ),
                trailing: Icon(
                  habit.category?.icon,
                  color: habit.isCompleted ? Colors.grey : Colors.white,
                ),
                onTap: () {
                  // Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //     builder: (context) => Edittasks(task: task)));
                },
              ),
            );
          },
        );
      },
    );
  }
}