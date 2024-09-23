import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/models/category.dart';
import 'package:to_do_planner/models/task.dart';
import 'package:to_do_planner/providers/taskProvider.dart';

class TaskForm extends StatefulWidget {
  const TaskForm({super.key});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _taskController = TextEditingController();
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  Category? _selectedCategory;

  final List<Category> _categories = [
    Category(name: 'Personal', icon: Icons.person),
    Category(name: 'Work', icon: Icons.work),
    Category(name: 'Health', icon: Icons.health_and_safety),
    Category(name: 'Home', icon: Icons.home),
    Category(name: 'Education', icon: Icons.menu_book),
    Category(name: 'Food', icon: Icons.fastfood),
    Category(name: 'Transport', icon: Icons.train),
    Category(name: 'Shopping', icon: Icons.shopping_cart),
    Category(name: 'Leisure', icon: Icons.sports_esports),
  ];

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
            cursorColor: Colors.white,
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
          DropdownButtonFormField<Category>(
              value: _selectedCategory,
              dropdownColor: const Color.fromARGB(255, 7, 36, 86),
              decoration: const InputDecoration(
                hintText: "Select Category",
                labelText: "Select Category",
                hintStyle: TextStyle(color: Colors.white),
                labelStyle: TextStyle(color: Colors.white),
                suffixIcon: Icon(Icons.collections_bookmark_outlined),
                suffixIconColor: Colors.white,
              ),
              items: _categories.map((Category category) {
                return DropdownMenuItem<Category>(
                    value: category,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            category.name,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Icon(category.icon, color: Colors.white,)
                        ],
                      ),
                    );
              }).toList(),
              onChanged: (Category? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              }),
          const SizedBox(
            height: 25,
          ),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            cursorColor: Colors.white,
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
              } else if (diff > 1 && date.month < 10) {
                _dateController.text =
                    "${date.day}-0${date.month}-${date.year}";
              } else if (diff > 1 && date.month > 10) {
                _dateController.text = "${date.day}-${date.month}-${date.year}";
              } else if (diff > 1 && date.day < 10) {
                _dateController.text =
                    "0${date.day}-${date.month}-${date.year}";
              } else if (diff > 1 && date.day > 10) {
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
            cursorColor: Colors.white,
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
                        ),
                      ),
                      child: child!);
                },
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time!.hour == 0 && time.minute == 0) {
                _timeController.text = "12:${time.minute}0 AM";
              } else if (time.hour < 12 && time.minute != 0) {
                _timeController.text = "${time.hour}:${time.minute} AM";
              } else if (time.hour < 12 && time.minute == 0) {
                _timeController.text = "${time.hour}:${time.minute}0 AM";
              } else if (time.hour == 12 && time.minute != 0) {
                _timeController.text = "${time.hour}:${time.minute} PM";
              } else if (time.hour == 12 && time.minute == 0) {
                _timeController.text = "${time.hour}:${time.minute}0 PM";
              } else if (time.hour > 12 && time.minute != 0) {
                _timeController.text = "${time.hour - 12}:${time.minute} PM";
              } else if (time.hour > 12 && time.minute == 0) {
                _timeController.text = "${time.hour - 12}:${time.minute}0 PM";
              }
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
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 20))),
              TextButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final task = Task(
                          title: _taskController.text,
                          category: _selectedCategory!,
                          date: _dateController.text,
                          time: _timeController.text);
                      Provider.of<TaskProvider>(context, listen: false)
                          .addTask(task);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Done',
                      style: TextStyle(color: Colors.white, fontSize: 20)))
            ],
          ),
        ],
      ),
    );
  }
}
