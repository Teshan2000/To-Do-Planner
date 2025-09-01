import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/components/taskForm.dart';
import 'package:to_do_planner/providers/taskProvider.dart';
import 'package:to_do_planner/screens/editTasks.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
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
        title: const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            "Tasks",
            style: TextStyle(color: Colors.white),
          ),
        ),        
        actions: const [
          Padding(
            padding: EdgeInsets.only(top: 20, right: 15),
            child: Icon(              
              Icons.check_circle,
              color: Colors.white,
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15))),
        backgroundColor: const Color.fromARGB(255, 15, 79, 189),
        bottom: const PreferredSize(
          preferredSize: Size(double.infinity, 15),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 3,
            ),
          ),
        ),
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
                                  backgroundColor: const Color.fromARGB(255, 15, 79, 189),
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
                        return null;
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
                          "${formatTaskDate(task.date)}, ${task.time}",
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
                    return const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(
                        height: 5,
                        color: Colors.white,
                      ),
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
                        return null;
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
                          "${formatTaskDate(task.date)}, ${task.time}",
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
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
