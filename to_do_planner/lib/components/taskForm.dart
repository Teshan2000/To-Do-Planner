import 'dart:developer';
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
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 25,
          ),
          TextFormField(
            controller: _taskController,
            style: const TextStyle(color: Colors.white),
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
            style: const TextStyle(color: Colors.white),
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
            readOnly: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Select Date",
              labelText: "Select Date",
              hintStyle: TextStyle(color: Colors.white),
              labelStyle: TextStyle(color: Colors.white),
              suffixIcon: Icon(Icons.calendar_month),
              suffixIconColor: Colors.white,
            ),
            onTap: () async {
              DateTime? date = await showDatePicker(
                  builder: (context, child) {
                    return Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: Color.fromARGB(255, 15, 79, 189),
                          onPrimary: Colors.white,
                          onSurface: Colors.black,
                        ),
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 15, 79, 189),
                            backgroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2100));
              log(date.toString());
              DateTime currentDate = DateTime.now();
              DateTime? now = DateTime(
                  currentDate.year, currentDate.month, currentDate.day);
              int diff = date!.difference(now).inDays;

              if (diff == 0) {
                _dateController.text = "Today";
              } else if (diff == 1) {
                _dateController.text = "Tomorrow";
              } else {
                _dateController.text = "${date.day}-${date.month}-${date.year}";
              }
            },
          ),
          const SizedBox(
            height: 25,
          ),
          TextFormField(
            controller: _timeController,
            readOnly: true,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Select Time",
              labelText: "Select Time",
              hintStyle: TextStyle(color: Colors.white),
              labelStyle: TextStyle(color: Colors.white),
              suffixIcon: Icon(Icons.timer_sharp),
              suffixIconColor: Colors.white,
            ),
            onTap: () async {
              TimeOfDay? time = await showTimePicker(
                builder: (context, child) {
                  return Theme(
                      data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                              primary: Color.fromARGB(255, 15, 79, 189),
                              secondary: Color.fromARGB(255, 15, 79, 189),
                              surface: Colors.white,
                              onSecondary: Colors.white,
                              onSurface: Colors.black),
                          textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                const Color.fromARGB(255, 15, 79, 189),
                            backgroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),),
                      child: child!);
                },
                context: context,
                initialTime: TimeOfDay.now(),
              );
              log(time.toString());
            },
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
