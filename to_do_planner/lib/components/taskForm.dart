import 'package:flutter/material.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _taskController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            "Create a new Task",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 25,
          ),
          TextFormField(
            controller: _taskController,
            decoration: const InputDecoration(
              hintText: "Title",
              labelText: "Enter Title",
              hintStyle: TextStyle(color: Colors.white),
              labelStyle: TextStyle(color: Colors.white),
              suffixIcon: Icon(Icons.task_outlined),
              suffixIconColor: Colors.white,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          TextFormField(
            controller: _taskController,
            decoration: const InputDecoration(
              hintText: "Select Category",
              labelText: "Select Category",
              hintStyle: TextStyle(color: Colors.white),
              labelStyle: TextStyle(color: Colors.white),
              suffixIcon: Icon(Icons.collections_bookmark_outlined),
              suffixIconColor: Colors.white,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          TextFormField(
            controller: _dateController,
            decoration: const InputDecoration(
              hintText: "Select Date",
              labelText: "Select Date",
              hintStyle: TextStyle(color: Colors.white),
              labelStyle: TextStyle(color: Colors.white),
              suffixIcon: Icon(Icons.calendar_month),
              suffixIconColor: Colors.white,
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          TextFormField(
            controller: _timeController,
            decoration: const InputDecoration(
              hintText: "Select Time",
              labelText: "Select Time",
              hintStyle: TextStyle(color: Colors.white),
              labelStyle: TextStyle(color: Colors.white),
              suffixIcon: Icon(Icons.timer_sharp),
              suffixIconColor: Colors.white,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {},
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 20))),
              TextButton(
                  onPressed: () {},
                  child: const Text('Done',
                      style: TextStyle(color: Colors.white, fontSize: 20)))
            ],
          ),
        ],
      ),
    );
  }
}
