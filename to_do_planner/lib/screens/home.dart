import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:to_do_planner/screens/calendar.dart';
import 'package:to_do_planner/screens/habitsScreen.dart';
// import 'package:to_do_planner/screens/newCalendar.dart';
import 'package:to_do_planner/screens/tasksScreen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool isCompleted = false;

  final List<Widget> _pages = [
    const TasksScreen(),
    const HabitsScreen(),
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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 36, 86),
      appBar: AppBar(
        title: const Text(
          "To Do Planner",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Calendar()));
            }, 
            icon: const Icon(Icons.calendar_month),
            color: Colors.white,
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 15, 79, 189),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: BottomNavigationBar(
            backgroundColor: const Color.fromARGB(255, 15, 79, 189),
            selectedItemColor: Colors.white,
            unselectedItemColor: const Color.fromARGB(255, 103, 153, 239),
            currentIndex: _selectedIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.task_outlined),
                activeIcon: Icon(Icons.task),
                label: "Tasks",
                tooltip: "Tasks",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.track_changes),
                label: "Habits",
                tooltip: "Habits",
              ),
            ],
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
        ),
   
    );
  }
}
