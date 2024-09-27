import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/components/taskForm.dart';
import 'package:to_do_planner/providers/taskProvider.dart';

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
                      title: Text(
                        task.title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      subtitle: Text(
                        "${task.date}, ${task.time}",
                        style: const TextStyle(
                            color: Color.fromARGB(255, 103, 153, 239)),
                      ),
                      trailing: Icon(task.category.icon, color: Colors.white,)
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
