import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/providers/taskProvider.dart';
import 'package:to_do_planner/screens/editTasks.dart';

class TodayTasksList extends StatefulWidget {
  final DateTime selectedDate;
  const TodayTasksList({required this.selectedDate, super.key});

  @override
  State<TodayTasksList> createState() => _TodayTasksListState();
}

class _TodayTasksListState extends State<TodayTasksList> {
  bool isCompleted = false;

  String formatTaskDate(DateTime taskDate) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));

    if (taskDate.isAtSameMomentAs(today)) {
      return "Today";
    } else if (taskDate.isAtSameMomentAs(tomorrow)) {
      return "Tomorrow";
    } else {
      return DateFormat("dd-MM-yyyy").format(taskDate);
    }
  }

  @override
  Widget build(BuildContext context) {    
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, _) {
        final todayTasks = TaskProvider().getTasksByDate(widget.selectedDate);
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todayTasks.length,
          separatorBuilder: (context, index) =>
              const Divider(height: 5, color: Colors.white),
          itemBuilder: (context, index) {
            final task = todayTasks[index];
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
                            "Delete ${task.title} ?",
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                taskProvider.removeTask(task);
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Edittasks(task: task)));
                }
              },
              onDismissed: (direction) {
                if (direction == DismissDirection.endToStart) {
                  taskProvider.removeTask(task);
                }
              },
              child: ListTile(
                leading: SizedBox(
                  width: 25,
                  child: Checkbox(
                      shape: const CircleBorder(side: BorderSide(width: 1.0)),
                      value: task.isCompleted,
                      onChanged: (value) {
                        setState(() {
                          taskProvider.completeTask(task);
                          isCompleted = true;
                        });
                      }),
                ),
                title: Text(
                  task.title,
                  style: TextStyle(
                    color: task.isCompleted ? Colors.grey : Colors.white,
                    fontSize: 18,
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Text(
                  "${formatTaskDate(task.date)}, ${task.time}",
                  style: const TextStyle(
                      color: Color.fromARGB(255, 103, 153, 239)),
                ),
                trailing: Icon(
                  task.category?.icon,
                  color: task.isCompleted ? Colors.grey : Colors.white,
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => Edittasks(task: task)));
                },
              ),
            );
          },
        );
      },
    );
  }
}