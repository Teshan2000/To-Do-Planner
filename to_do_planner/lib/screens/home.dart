import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/components/taskForm.dart';
import 'package:to_do_planner/providers/taskProvider.dart';
import 'package:to_do_planner/screens/editTasks.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
          return Column(
            children: [
              SizedBox(
                height: 250,
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    final task = taskProvider.tasks[index];
                    return ListTile(
                      leading: SizedBox(
                        width: 25,
                        child: Checkbox(
                            shape: const CircleBorder(
                                side: BorderSide(width: 1.0)),
                            value: task.isCompleted,
                            onChanged: (value) {
                              setState(() {
                                task.isCompleted = value ?? false;
                              });
                              // taskProvider.updateTask(oldTask, newTask);
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
                        "${task.date}, ${task.time}",
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
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor: const Color.fromARGB(255, 15, 79, 189),
                                title: Text("Delete ${task.title} ?",
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
                                    child: const Text("Delete", 
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel", 
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                    );
                  },
                  itemCount: taskProvider.tasks.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.white,
                    );
                  },
                ),
              ),
            ],
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
                                child: Expanded(
                                  // height: 700,
                                  // width: double.infinity,
                                  // padding:
                                  //     const EdgeInsets.fromLTRB(25, 30, 25, 25),
                                  child: TaskForm(),
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
