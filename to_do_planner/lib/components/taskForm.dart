import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/models/category.dart';
import 'package:to_do_planner/models/task.dart';
import 'package:to_do_planner/providers/notificationService.dart';
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
  String? _selectedReminder;
  String? _selectedRepeat;
  bool _reminderEnabled = false;
  final Notificationservice notificationservice = Notificationservice();

  @override
  void initState() {
    super.initState();
    notificationservice.initialize();
  }

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

  final List<String> _reminderOptions = [
    '5 minutes before',
    '10 minutes before',
    '15 minutes before',
    '20 minutes before',
    '1 hour before',
    '2 hours before',
    '1 day before',
    '2 days before',
  ];

  final List<String> _repeatOptions = [
    'Hourly',
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
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
                      Icon(
                        category.icon,
                        color: Colors.white,
                      )
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
                  builder: (context, child) => Theme(
                      data: ThemeData().copyWith(
                          datePickerTheme: const DatePickerThemeData(
                              headerBackgroundColor:
                                  Color.fromARGB(255, 5, 46, 80),
                              headerForegroundColor: Colors.white,
                              cancelButtonStyle: ButtonStyle(
                                  foregroundColor:
                                      WidgetStatePropertyAll(Colors.white)),
                              confirmButtonStyle: ButtonStyle(
                                  foregroundColor:
                                      WidgetStatePropertyAll(Colors.white)),
                              backgroundColor: Color.fromARGB(255, 0, 82, 223),
                              dividerColor: Color.fromARGB(255, 5, 46, 80)),
                          colorScheme: const ColorScheme.light(
                            primary: Colors.blueAccent,
                            onPrimary: Colors.white,
                            onSurface: Colors.white,
                          )),
                      child: child!),
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
                builder: (context, child) => Theme(
                    data: ThemeData().copyWith(
                        timePickerTheme: const TimePickerThemeData(
                            backgroundColor: Color.fromARGB(255, 5, 46, 80),
                            dialBackgroundColor:
                                Color.fromARGB(255, 0, 82, 223),
                            dialHandColor: Colors.blueAccent,
                            entryModeIconColor: Colors.white,
                            cancelButtonStyle: ButtonStyle(
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.white)),
                            confirmButtonStyle: ButtonStyle(
                                foregroundColor:
                                    WidgetStatePropertyAll(Colors.white)),
                            hourMinuteTextColor: Colors.white,
                            helpTextStyle: TextStyle(
                              color: Colors.white,
                            ),
                            hourMinuteColor: Color.fromARGB(255, 0, 82, 223),
                            dayPeriodColor: Color.fromARGB(255, 0, 82, 223),
                            dayPeriodTextColor: Colors.white),
                        colorScheme: const ColorScheme.light(
                          onSurface: Colors.white,
                          primary: Colors.blueAccent,
                          onPrimary: Colors.white,
                        )),
                    child: child!),
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (time!.hour == 0 && time.minute != 0) {
                _timeController.text = "12:${time.minute} AM";
              } else if (time.hour == 0 && time.minute == 0) {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Add Reminder',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              FlutterSwitch(
                value: _reminderEnabled,
                onToggle: (val) {
                  setState(() {
                    _reminderEnabled = val;
                  });
                },
                activeToggleColor: Colors.white,
                activeColor: const Color.fromARGB(255, 7, 36, 86),
                inactiveToggleColor: const Color.fromARGB(255, 103, 153, 239),
                inactiveColor: Colors.white,
                height: 30,
                width: 60,
                borderRadius: 30.0,
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          if (_reminderEnabled)
            DropdownButtonFormField<String>(
                value: _selectedReminder,
                dropdownColor: const Color.fromARGB(255, 7, 36, 86),
                decoration: const InputDecoration(
                  hintText: "Select Reminder",
                  labelText: "Select Reminder",
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  suffixIcon: Icon(Icons.notifications_outlined),
                  suffixIconColor: Colors.white,
                ),
                items: _reminderOptions.map((String option) {
                  return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedReminder = newValue;
                  });
                }),
          const SizedBox(
            height: 20,
          ),
          if (_reminderEnabled)
            DropdownButtonFormField<String>(
                value: _selectedRepeat,
                dropdownColor: const Color.fromARGB(255, 7, 36, 86),
                decoration: const InputDecoration(
                  hintText: "Select Repeat",
                  labelText: "Select Repeat",
                  hintStyle: TextStyle(color: Colors.white),
                  labelStyle: TextStyle(color: Colors.white),
                  suffixIcon: Icon(Icons.repeat),
                  suffixIconColor: Colors.white,
                ),
                items: _repeatOptions.map((String option) {
                  return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 16)));
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedRepeat = newValue;
                  });
                }),
          if (_reminderEnabled)
            const SizedBox(
              height: 20,
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
                        category: _selectedCategory,
                        date: _dateController.text,
                        time: _timeController.text,
                        reminder: _selectedReminder,
                        repeat: _selectedRepeat,
                      );
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
