import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/providers/habitProvider.dart';
import 'package:to_do_planner/screens/editTasks.dart';

class CompletedTodayHabitsList extends StatefulWidget {
  final DateTime selectedDate;
  const CompletedTodayHabitsList({required this.selectedDate, super.key});

  @override
  State<CompletedTodayHabitsList> createState() =>
      _CompletedTodayHabitsListState();
}

class _CompletedTodayHabitsListState extends State<CompletedTodayHabitsList> {
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
        return Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            if (habitProvider.completedHabits.isNotEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Row(children: <Widget>[
                  Text(
                    "Completed Habits",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ]),
              ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final habit = habitProvider.completedHabits[index];
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
                      //     builder: (context) => Edithabits(habit: habit)));
                    }
                    return null;
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
                          shape:
                              const CircleBorder(side: BorderSide(width: 1.0)),
                          value: habit.isCompletedToday(),
                          onChanged: (value) {
                            setState(() {
                              habitProvider.completeHabit(
                                  habit, DateTime.now());
                              isCompleted = true;
                            });
                          }),
                    ),
                    title: Text(
                      habit.title,
                      style: TextStyle(
                        color: habit.isCompletedToday()
                            ? Colors.grey
                            : Colors.white,
                        fontSize: 18,
                        decoration: habit.isCompletedToday()
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    subtitle: Text("Streak: ${habit.getStreak()} days",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 103, 153, 239))),
                    trailing: Icon(
                      habit.category?.icon,
                      color:
                          habit.isCompletedToday() ? Colors.grey : Colors.white,
                    ),
                    onTap: () {
                      // Navigator.of(context).pushReplacement(MaterialPageRoute(
                      //     builder: (context) => Edithabits(habit: habit)));
                    },
                  ),
                );
              },
              itemCount: habitProvider.completedHabits.length,
              separatorBuilder: (context, index) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    height: 5,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
