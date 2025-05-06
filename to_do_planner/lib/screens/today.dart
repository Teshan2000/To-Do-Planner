import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_planner/models/habit.dart';
import 'package:to_do_planner/models/task.dart';
import 'package:to_do_planner/providers/habitProvider.dart';
import 'package:to_do_planner/providers/taskProvider.dart';

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

enum FilterStatus { All, Tasks, Habits }

class _TodayState extends State<Today> {
  bool isCompleted = false;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  FilterStatus status = FilterStatus.All;
  Alignment _alignment = Alignment.centerLeft;

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
    List<Map<String, dynamic>> getEventsByDate(DateTime day) {
      final tasks = TaskProvider()
          .getTasksByDate(_selectedDay)
          .map((task) => {'type': 'task', 'data': task})
          .toList();

      final habits = HabitProvider()
          .getHabitsByDate(_selectedDay)
          .map((habit) => {'type': 'habit', 'data': habit})
          .toList();

      return [...tasks, ...habits];
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 36, 86),
      appBar: AppBar(
        title: const Text(
          "Today",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.calendar_month),
            color: Colors.white,
          ),
        ],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        backgroundColor: const Color.fromARGB(255, 15, 79, 189),
      ),
      body: Consumer2<TaskProvider, HabitProvider>(
        builder: (context, taskProvider, habitProvider, _) {
          return SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 20),
              TableCalendar(
                focusedDay: _focusedDay,
                firstDay: DateTime(2000),
                lastDay: DateTime(2100),
                calendarFormat: CalendarFormat.week,
                headerVisible: false,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.white),
                  weekendStyle: TextStyle(color: Colors.white),
                ),
                calendarStyle: const CalendarStyle(
                  isTodayHighlighted: true,
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
              const SizedBox(height: 20),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      width: double.infinity,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          for (FilterStatus filterStatus in FilterStatus.values)
                            Expanded(
                                child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (filterStatus == FilterStatus.All) {
                                    status = FilterStatus.All;
                                    _alignment = Alignment.centerLeft;
                                  } else if (filterStatus ==
                                      FilterStatus.Tasks) {
                                    status = FilterStatus.Tasks;
                                    _alignment = Alignment.center;
                                  } else if (filterStatus ==
                                      FilterStatus.Habits) {
                                    status = FilterStatus.Habits;
                                    _alignment = Alignment.centerRight;
                                  }
                                });
                              },
                              child: Center(child: Text(filterStatus.name)),
                            ))
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: AnimatedAlign(
                      alignment: _alignment,
                      duration: const Duration(milliseconds: 200),
                      child: Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 15, 79, 189),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                            child: Text(
                          status.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                  child: ListView(
                    children: getEventsByDate(_selectedDay ?? _focusedDay)
                        .map((event) {
                      if (event['type'] == 'task') {
                        Task task = event['data'];
                        return Dismissible(
                          key: Key(toString()),
                          child: ListTile(
                            // leading: Icon(task.category?.icon, color: Colors.white),
                            title: Text(task.title,
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text("Task | ${task.time}",
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 103, 153, 239))),
                            trailing:
                                Icon(task.category?.icon, color: Colors.white),
                          ),
                        );
                      } else if (event['type'] == 'habit') {
                        Habit habit = event['data'];
                        return ListTile(
                          // leading: Icon(habit.category?.icon, color: Colors.white),
                          title: Text(habit.title,
                              style: const TextStyle(color: Colors.white)),
                          subtitle: Text(
                              "Habit | ${formatTaskDate(habit.startDate)}",
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 103, 153, 239))),
                          trailing:
                              Icon(habit.category?.icon, color: Colors.white),
                        );
                      }
                      return const SizedBox.shrink();
                    }).toList(),
                  ),
                ),
              ]                
            ),
          );
        },
      ),
    );
  }
}