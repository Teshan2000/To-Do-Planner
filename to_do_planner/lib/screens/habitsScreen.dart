import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/components/habitForm.dart';
import 'package:to_do_planner/providers/habitProvider.dart';
import 'package:to_do_planner/screens/editHabits.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 36, 86),
      appBar: AppBar(
        title: const Text(
          "Habits",
          style: TextStyle(color: Colors.white),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15), 
            bottomRight: Radius.circular(15)
          )
        ),
        backgroundColor: const Color.fromARGB(255, 15, 79, 189),
      ),
      body: Consumer<HabitProvider>(
        builder: (context, habitProvider, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),                  
                  itemBuilder: (context, index) {
                    final habit = habitProvider.habits[index];
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
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Edithabits(habit: habit)));
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
                            shape: const CircleBorder(
                              side: BorderSide(width: 1.0)),
                            value: habit.isCompleted,
                            onChanged: (value) {
                              setState(() {
                                habitProvider.completeHabit(habit, DateTime.now());
                                isCompleted = true;
                              });
                            }
                          ),
                        ),
                        title: Text(
                          habit.title,
                          style: TextStyle(
                            color: habit.isCompleted ? Colors.grey : Colors.white,
                            fontSize: 18,
                            decoration: habit.isCompleted
                              ? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text("Streak: ${habit.getStreak()} days",
                          style: const TextStyle(color: Color.fromARGB(255, 103, 153, 239))),
                        trailing: Icon(
                          habit.category?.icon,
                          color: habit.isCompleted ? Colors.grey : Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => Edithabits(habit: habit)));
                        },
                      ),
                    );
                  },
                  itemCount: habitProvider.habits.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.white,
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                if (habitProvider.completedHabits.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: Row(children: <Widget>[
                      Text(
                        "Completed",
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
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Edithabits(habit: habit)));
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
                            shape: const CircleBorder(
                              side: BorderSide(width: 1.0)),
                            value: habit.isCompletedToday(),
                            onChanged: (value) {
                              setState(() {
                                habitProvider.completeHabit(habit, DateTime.now());
                                isCompleted = true;
                              });
                            }
                          ),
                        ),
                        title: Text(
                          habit.title,
                          style: TextStyle(
                            color: habit.isCompletedToday() ? Colors.grey : Colors.white,
                            fontSize: 18,
                            decoration: habit.isCompletedToday()
                              ? TextDecoration.lineThrough : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text("Streak: ${habit.getStreak()} days",
                          style: const TextStyle(color: Color.fromARGB(255, 103, 153, 239))),
                        trailing: Icon(
                          habit.category?.icon,
                          color: habit.isCompletedToday() ? Colors.grey : Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => Edithabits(habit: habit)));
                        },
                      ),
                    );
                  },
                  itemCount: habitProvider.completedHabits.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.white,
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 15, 79, 189),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (_) => const Padding(
              padding: EdgeInsets.all(10),
              child: Dialog(
                backgroundColor: Color.fromARGB(255, 15, 79, 189),
                insetPadding: EdgeInsets.all(10),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(25, 30, 25, 25),
                        child: Column(
                          children: [
                            HabitForm(),
                          ],
                        ),
                      ),
                    ),
                  ]
                ),
              ),
            )
          );
        },
        shape: const CircleBorder(side: BorderSide.none),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
