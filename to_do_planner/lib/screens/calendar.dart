import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_planner/models/habit.dart';
import 'package:to_do_planner/models/task.dart';
import 'package:to_do_planner/providers/habitProvider.dart';
import 'package:to_do_planner/providers/taskProvider.dart';
import 'package:to_do_planner/screens/home.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String formatTaskDate(DateTime taskDate) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));

    if (taskDate.isAtSameMomentAs(today)) {
      return "Today";
    } else if (taskDate.isAtSameMomentAs(tomorrow)) {
      return "Tomorrow";
    } else {
      return DateFormat("dd-MM-yyyy")
          .format(taskDate); // Format for other dates
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final habitProvider = Provider.of<HabitProvider>(context);

    List<Map<String, dynamic>> getEventsByDate(DateTime day) {
      final tasks = taskProvider
          .getTasksByDate(day)
          .map((task) => {'type': 'task', 'data': task})
          .toList();

      final habits = habitProvider
          .getHabitsByDate(day)
          .map((habit) => {'type': 'habit', 'data': habit})
          .toList();

      return [...tasks, ...habits];
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 36, 86),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 15, 79, 189),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Home()));
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
        centerTitle: true,
        title: const Text(
          'Task Calendar',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) => getEventsByDate(day),
            headerStyle: const HeaderStyle(
              titleTextStyle: TextStyle(color: Colors.white),
              formatButtonTextStyle: TextStyle(color: Colors.white),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 5, 46, 80),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Colors.white),
              weekendStyle: TextStyle(color: Colors.white),
            ),
            calendarStyle: const CalendarStyle(
              defaultTextStyle: TextStyle(color: Colors.white),
              weekendTextStyle: TextStyle(color: Colors.white),
              markerDecoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              children: getEventsByDate(_selectedDay ?? _focusedDay).map((event) {
                if (event['type'] == 'task') {
                  Task task = event['data'];
                  return ListTile(
                    // leading: Icon(task.category?.icon, color: Colors.white),
                    title: Text(task.title,
                      style: const TextStyle(color: Colors.white)),
                    subtitle: Text("${formatTaskDate(task.date)}, ${task.time}",
                      style: const TextStyle(color: Colors.grey)),
                    trailing: Icon(task.category?.icon, color: Colors.white),
                  );
                } else if (event['type'] == 'habit') {
                  Habit habit = event['data'];
                  return ListTile(
                    // leading: Icon(habit.category?.icon, color: Colors.white),
                    title: Text(habit.title,
                      style: const TextStyle(color: Colors.white)),
                    subtitle: Text("${formatTaskDate(habit.startDate)}",
                      style: const TextStyle(color: Colors.grey)),
                    trailing: Icon(habit.category?.icon, color: Colors.white),
                  );
                }
                return const SizedBox.shrink();
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
