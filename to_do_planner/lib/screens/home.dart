import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/components/taskForm.dart';
import 'package:to_do_planner/providers/taskProvider.dart';
import 'package:to_do_planner/screens/calendar.dart';
import 'package:to_do_planner/screens/editTasks.dart';
import 'package:to_do_planner/screens/newCalendar.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 36, 86),
      appBar: AppBar(
        title: const Text(
          "To Do Planner",
          style: TextStyle(color: Colors.white),
        ),        
        backgroundColor: const Color.fromARGB(255, 15, 79, 189),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];
                    final formattedDate = formatTaskDate(task.date);
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
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
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
                              shape: const CircleBorder(
                                  side: BorderSide(width: 1.0)),
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
                            color:
                                task.isCompleted ? Colors.grey : Colors.white,
                            fontSize: 18,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(
                          "${formattedDate}, ${task.time}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 103, 153, 239)),
                        ),
                        trailing: Icon(
                          task.category?.icon,
                          color: task.isCompleted ? Colors.grey : Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Edittasks(task: task)));
                        },
                      ),
                    );
                  },
                  itemCount: taskProvider.tasks.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.white,
                    );
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                if (taskProvider.completedTasks.isNotEmpty)
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
                    final task = taskProvider.completedTasks[index];
                    return Dismissible(
                      key: Key(index.toString()),
                      background: Container(
                        color: const Color.fromARGB(255, 103, 153, 239),
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 25,
                            ),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.edit, color: Colors.white)),
                          ],
                        ),
                      ),
                      secondaryBackground: Container(
                        color: const Color.fromARGB(255, 103, 153, 239),
                        child: const Row(
                          children: [
                            Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.delete, color: Colors.white)),
                            SizedBox(
                              width: 25,
                            ),
                          ],
                        ),
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
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
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
                              shape: const CircleBorder(
                                  side: BorderSide(width: 1.0)),
                              value: task.isCompleted,
                              onChanged: (value) {
                                setState(() {
                                  taskProvider.completeTask(task);
                                });
                                // taskProvider.updateTask(oldTask, newTask);
                              }),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            color:
                                task.isCompleted ? Colors.grey : Colors.white,
                            fontSize: 18,
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                        subtitle: Text(
                          "${task.date}, ${task.time}",
                          style: const TextStyle(
                              color: Color.fromARGB(255, 103, 153, 239)),
                        ),
                        trailing: Icon(
                          task.category?.icon,
                          color: task.isCompleted ? Colors.grey : Colors.white,
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => Edittasks(task: task)));
                        },
                        onLongPress: () {
                          setState(() {
                            task.isCompleted = true;
                          });
                        },
                      ),
                    );
                  },
                  itemCount: taskProvider.completedTasks.length,
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
                                    TaskForm(),
                                  ],
                                  // height: 700,
                                  // width: double.infinity,
                                  // padding:
                                  //     const EdgeInsets.fromLTRB(25, 30, 25, 25),
                                ),
                              ),
                            ),
                          ]),
                    ),
                  ));
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
