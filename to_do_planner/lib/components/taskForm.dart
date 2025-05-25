import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/models/category.dart';
import 'package:to_do_planner/models/task.dart';
import 'package:to_do_planner/providers/notificationService.dart';
import 'package:to_do_planner/providers/taskProvider.dart';
import 'package:to_do_planner/screens/home.dart';

class TaskForm extends StatefulWidget {
  final Task? task;
  const TaskForm({super.key, this.task});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _taskController = TextEditingController();
  final _timeController = TextEditingController();
  DateTime? _selectedDate;
  Category? _selectedCategory;
  String? _selectedReminder;
  String? _selectedRepeat;
  bool _reminderEnabled = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _taskController.text = widget.task!.title;
      _selectedCategory = _categories.firstWhere(
        (category) => category == widget.task!.category,
      );
      _selectedDate = widget.task!.date;
      _timeController.text = widget.task!.time;
      _reminderEnabled = widget.task!.reminder != null;
      _selectedReminder = widget.task!.reminder;
      _selectedRepeat = widget.task!.repeat;
    }
  }

  void _saveTask(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please select a date")),
        );
        return;
      }
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      final timeParts = _timeController.text.split(" ");
      final rawTime = timeParts[0].split(":");
      int hour = int.parse(rawTime[0]);
      int minute = int.parse(rawTime[1]);
      final timeFormat = timeParts[1].toLowerCase() == "pm";

      if (timeFormat && hour != 12) {
        hour += 12;
      } else if (!timeFormat && hour == 12) {
        hour = 0;
      }

      DateTime taskDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        hour,
        minute,
      );

      String formattedDate = DateFormat("dd-MM-yyyy").format(_selectedDate!);
      String formattedTime = DateFormat("h:mm a").format(taskDateTime);

      if (_selectedReminder != null) {
        switch (_selectedReminder) {
          case '5 minutes before':
            taskDateTime = taskDateTime.subtract(const Duration(minutes: 5));
            break;
          case '10 minutes before':
            taskDateTime = taskDateTime.subtract(const Duration(minutes: 10));
            break;
          case '15 minutes before':
            taskDateTime = taskDateTime.subtract(const Duration(minutes: 15));
            break;
          case '1 hour before':
            taskDateTime = taskDateTime.subtract(const Duration(hours: 1));
            break;
          case '1 day before':
            taskDateTime = taskDateTime.subtract(const Duration(days: 1));
            break;
        }
      }

      final newTask = Task(
        title: _taskController.text,
        category: _selectedCategory,
        date: _selectedDate!,
        time: _timeController.text,
        reminder: _reminderEnabled ? _selectedReminder : null,
        repeat: _selectedRepeat,
      );

      if (widget.task != null) {
        taskProvider.updateTask(widget.task!, newTask);
      } else {
        taskProvider.addTask(newTask);
      }

      if (_reminderEnabled) {
        NotificationService.scheduleNotification(
          title: _taskController.text,
          body: _timeController.text,
          category: _selectedCategory?.icon,
          scheduledDate: taskDateTime,
          repeat: _selectedRepeat,
        );
        print(
            "Notification scheduled for: $taskDateTime with repeat: $_selectedRepeat");
      }

      Navigator.pop(context);
    }
  }

  final List<Category> _categories = [
    Category(name: 'Personal', icon: Icons.person),
    Category(name: 'Home', icon: Icons.home),
    Category(name: 'Work', icon: Icons.work),  
    Category(name: 'Food', icon: Icons.fastfood),
    Category(name: 'Health', icon: Icons.health_and_safety),
    Category(name: 'Finance', icon: Icons.monetization_on),
    Category(name: 'Education', icon: Icons.menu_book),    
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
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Text(
            widget.task != null ? "Edit your Task" : "Create a new Task",
            style: const TextStyle(
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
            controller: TextEditingController(
              text: _selectedDate != null ? formatTaskDate(_selectedDate!) : '',
            ),
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
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2100));
              if (date != null) {
                setState(() {
                  _selectedDate = date;
                });
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
                    // _reminderEnabled = true;
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
                    widget.task != null
                        ? Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const Home()))
                        : Navigator.of(context).pop();
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 20))),
              widget.task != null
                  ? TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Task updatedTask = Task(
                            title: _taskController.text,
                            category: _selectedCategory,
                            date: _selectedDate!,
                            time: _timeController.text,
                            reminder: _selectedReminder,
                            repeat: _selectedRepeat,
                          );
                          Provider.of<TaskProvider>(context, listen: false)
                              .updateTask(widget.task!, updatedTask);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const Home()));
                        }
                      },
                      child: const Text('Update',
                          style: TextStyle(color: Colors.white, fontSize: 20)))
                  : TextButton(
                      onPressed: () {
                        // if (_formKey.currentState!.validate()) {
                        // final task = Task(
                        //   title: _taskController.text,
                        //   category: _selectedCategory,
                        //   date: _selectedDate!,
                        //   time: _timeController.text,
                        //   reminder: _selectedReminder,
                        //   repeat: _selectedRepeat,
                        // );
                        // Provider.of<TaskProvider>(context, listen: false)
                        //     .addTask(task);
                        // if (_reminderEnabled) {
                        //   scheduleReminderNotifications(context);
                        // }
                        // Navigator.of(context).pop();
                        _saveTask(context);
                        // }
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
