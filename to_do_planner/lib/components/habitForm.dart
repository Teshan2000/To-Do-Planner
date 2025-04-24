import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/models/category.dart';
import 'package:to_do_planner/models/habit.dart';
import 'package:to_do_planner/providers/habitProvider.dart';
import 'package:to_do_planner/providers/notificationService.dart';
import 'package:to_do_planner/screens/home.dart';

class HabitForm extends StatefulWidget {
  final Habit? habit;
  const HabitForm({super.key, this.habit});

  @override
  State<HabitForm> createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  final _formKey = GlobalKey<FormState>();
  final _habitController = TextEditingController();
  DateTime? _startDate;
  Category? _selectedCategory;
  String? _selectedReminder;
  String? _selectedRepeat;
  bool _reminderEnabled = false;

  @override
  void initState() {
    super.initState();
    if (widget.habit != null) {
      _habitController.text = widget.habit!.title;
      _selectedCategory = _categories.firstWhere(
        (category) => category == widget.habit!.category,
      );
      _startDate = widget.habit!.startDate;
      _reminderEnabled = widget.habit!.reminder != null;
      _selectedReminder = widget.habit!.reminder;
    }
  }

  void _saveHabit(BuildContext context) {
    // if (_formKey.currentState!.validate()) {
      // if (_selectedDate == null) {
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     const SnackBar(content: Text("Please select a date")),
      //   );
      //   return;
      // }
      final habitProvider = Provider.of<HabitProvider>(context, listen: false);

      // final timeParts = _timeController.text.split(" ");
      // final rawTime = timeParts[0].split(":");
      // int hour = int.parse(rawTime[0]);
      // int minute = int.parse(rawTime[1]);
      // final timeFormat = timeParts[1].toLowerCase() == "pm";

      // if (timeFormat && hour != 12) {
      //   hour += 12;
      // } else if (!timeFormat && hour == 12) {
      //   hour = 0;
      // }

      // DateTime habitDateTime = DateTime(
      //   _selectedDate!.year,
      //   _selectedDate!.month,
      //   _selectedDate!.day,
      //   hour,
      //   minute,
      // );

      // String formattedDate = DateFormat("dd-MM-yyyy").format(_selectedDate!);
      // String formattedTime = DateFormat("h:mm a").format(habitDateTime);

      // if (_selectedReminder != null) {
      //   switch (_selectedReminder) {
      //     case '5 minutes before':
      //       habitDateTime = habitDateTime.subtract(const Duration(minutes: 5));
      //       break;
      //     case '10 minutes before':
      //       habitDateTime = habitDateTime.subtract(const Duration(minutes: 10));
      //       break;
      //     case '15 minutes before':
      //       habitDateTime = habitDateTime.subtract(const Duration(minutes: 15));
      //       break;
      //     case '1 hour before':
      //       habitDateTime = habitDateTime.subtract(const Duration(hours: 1));
      //       break;
      //     case '1 day before':
      //       habitDateTime = habitDateTime.subtract(const Duration(days: 1));
      //       break;
      //   }
      // }

      final newHabit = Habit(
        title: _habitController.text,
        category: _selectedCategory,
        // date: _selectedDate!,
        startDate: _startDate!,
        streak: 0,
        completion: [],
        reminder: _reminderEnabled ? _selectedReminder : null,
      );

      if (widget.habit != null) {
        habitProvider.updateHabit(widget.habit!, newHabit);
      } else {
        habitProvider.addHabit(newHabit);
      }

      // if (_reminderEnabled) {
      //   NotificationService.scheduleNotification(
      //     title: "Habit Reminder",
      //     body: "Reminder for: ${_habitController.text}",
      //     scheduledDate: habitDateTime,
      //     repeat: _selectedRepeat,
      //   );
      //   print(
      //     "Notification scheduled for: $habitDateTime with repeat: $_selectedRepeat");
      // }
      Navigator.pop(context);
    // }
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

  // final List<String> _repeatOptions = [
  //   'Hourly',
  //   'Daily',
  //   'Weekly',
  //   'Monthly',
  //   'Yearly',
  // ];

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
            widget.habit != null ? "Edit your Habit" : "Create a new Habit",
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 25,
          ),
          TextFormField(
            controller: _habitController,
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: "Title",
              labelText: "Enter Title",
              hintStyle: TextStyle(color: Colors.white),
              labelStyle: TextStyle(color: Colors.white),
              suffixIcon: Icon(Icons.track_changes),
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
              text: _startDate != null ? formatTaskDate(_startDate!) : '',
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
                  initialDate: _startDate ?? DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2100));
              if (date != null) {
                setState(() {
                  _startDate = date;
                });
              }
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
          // if (_reminderEnabled)
          //   DropdownButtonFormField<String>(
          //       value: _selectedRepeat,
          //       dropdownColor: const Color.fromARGB(255, 7, 36, 86),
          //       decoration: const InputDecoration(
          //         hintText: "Select Repeat",
          //         labelText: "Select Repeat",
          //         hintStyle: TextStyle(color: Colors.white),
          //         labelStyle: TextStyle(color: Colors.white),
          //         suffixIcon: Icon(Icons.repeat),
          //         suffixIconColor: Colors.white,
          //       ),
          //       items: _repeatOptions.map((String option) {
          //         return DropdownMenuItem<String>(
          //             value: option,
          //             child: Text(option,
          //                 style: const TextStyle(
          //                     color: Colors.white, fontSize: 16)));
          //       }).toList(),
          //       onChanged: (String? newValue) {
          //         setState(() {
          //           _selectedRepeat = newValue;
          //         });
          //       }),
          if (_reminderEnabled)
            const SizedBox(
              height: 20,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    widget.habit != null
                        ? Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (context) => const Home()))
                        : Navigator.of(context).pop();
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.white, fontSize: 20))),
              widget.habit != null
                  ? TextButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Habit updatedHabit = Habit(
                            title: _habitController.text,
                            category: _selectedCategory,
                            completion: [],
                            streak: 0,
                            startDate: _startDate!,
                            reminder: _selectedReminder,
                          );
                          Provider.of<HabitProvider>(context, listen: false)
                              .updateHabit(widget.habit!, updatedHabit);
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const Home()));
                        }
                      },
                      child: const Text('Update', style: TextStyle(
                        color: Colors.white, fontSize: 20)))
                        : TextButton(
                        onPressed: () {
                          _saveHabit(context);
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
