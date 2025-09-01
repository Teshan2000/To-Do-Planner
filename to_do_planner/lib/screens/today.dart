import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do_planner/components/completedHabitsList.dart';
import 'package:to_do_planner/components/completedTasksList.dart';
import 'package:to_do_planner/components/habitsList.dart';
import 'package:to_do_planner/components/tasksList.dart';
import 'package:to_do_planner/models/habit.dart';
import 'package:to_do_planner/models/task.dart';
import 'package:to_do_planner/providers/habitProvider.dart';
import 'package:to_do_planner/providers/taskProvider.dart';

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  String selectedFilter = 'All';
  String? selectedCategory;
  bool isCompleted = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;

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

  Widget _buildFilterChip(String label) {
    final isSelected = selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        showCheckmark: false,
        label: Text(label),
        selected: isSelected,
        selectedColor: const Color.fromARGB(255, 15, 79, 189),
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        onSelected: (_) => _applyFilter(label),
      ),
    );
  }

  Widget _buildCategoryChip(String categoryName) {
    final isSelected = selectedCategory == categoryName;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ChoiceChip(
        showCheckmark: false,
        label: Text(categoryName),
        selected: isSelected,
        selectedColor: Colors.blueAccent,
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
        onSelected: (_) {
          setState(() {
            selectedCategory = isSelected ? null : categoryName; // toggle
          });
        },
      ),
    );
  }

  void _applyFilter(String filter) {
    setState(() {
      selectedFilter = filter;
    });
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

    List<dynamic> filteredItems;
    if (selectedFilter == 'Tasks') {
      filteredItems = taskProvider.tasks;
    } else if (selectedFilter == 'Habits') {
      filteredItems = habitProvider.habits;
    } else {
      filteredItems = [...taskProvider.tasks, ...habitProvider.habits];
    }

    if (selectedCategory != null) {
      filteredItems = filteredItems.where((item) {
        if (item is Task) {
          return item.category?.name == selectedCategory;
        } else if (item is Habit) {
          return item.category?.name == selectedCategory;
        }
        return false;
      }).toList();
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 36, 86),
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 20),
          child: Text(
            "Today",
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(top: 20, right: 15),
            child: Icon(
              Icons.view_list,
              color: Colors.white,
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        backgroundColor: const Color.fromARGB(255, 15, 79, 189),
        bottom: const PreferredSize(
          preferredSize: Size(double.infinity, 15),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 3,
            ),
          ),
        ),
      ),
      body: Consumer2<TaskProvider, HabitProvider>(
        builder: (context, taskProvider, habitProvider, _) {
          return SingleChildScrollView(
            child: Column(children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TableCalendar(
                  focusedDay: _focusedDay,
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  calendarFormat: _calendarFormat,
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  headerVisible: false,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  // headerStyle: const HeaderStyle(
                  //   titleTextStyle: TextStyle(color: Colors.white),
                  //   formatButtonTextStyle: TextStyle(color: Colors.white),
                  //   decoration: BoxDecoration(
                  //     color: Color.fromARGB(255, 5, 46, 80),
                  //     borderRadius: BorderRadius.all(Radius.circular(10)),
                  //   ),
                  // ),
                  eventLoader: (day) => getEventsByDate(day),
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
                    todayDecoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Color.fromARGB(255, 103, 153, 239),
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All'),
                      _buildFilterChip('Tasks'),
                      _buildFilterChip('Habits'),
                      ...taskProvider.tasks
                        .map((task) => task.category?.name)
                        .where((name) => name != null)
                        .toSet()
                        .map((name) => _buildCategoryChip(name!)),
                      ...habitProvider.habits
                        .map((habit) => habit.category?.name)
                        .where((name) => name != null)
                        .toSet()
                        .map((name) => _buildCategoryChip(name!)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (selectedFilter == 'All' || selectedFilter == 'Tasks') ...[
                TodayTasksList(selectedDate: _selectedDay ?? DateTime.now()),
                CompletedTasksList(selectedDate: _selectedDay ?? DateTime.now()),
              ],
              if (selectedFilter == 'All' || selectedFilter == 'Habits') ...[
                TodayHabitsList(selectedDate: _selectedDay ?? DateTime.now()),
                CompletedTodayHabitsList(selectedDate: _selectedDay ?? DateTime.now()),
              ],
            ]                
          ),
          );
        },
      ),
    );
  }
}


