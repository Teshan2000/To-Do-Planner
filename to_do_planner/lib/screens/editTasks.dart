import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/components/taskForm.dart';
import 'package:to_do_planner/models/task.dart';
import 'package:to_do_planner/providers/taskProvider.dart';
import 'package:to_do_planner/screens/home.dart';

class Edittasks extends StatelessWidget {
  final Task task;
  const Edittasks({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 7, 36, 86),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 15, 79, 189),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: Padding(
          padding: EdgeInsets.all(20), 
          child: TaskForm(task: task)
        )
      );
  }
}
