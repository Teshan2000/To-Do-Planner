import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/components/habitForm.dart';
import 'package:to_do_planner/components/taskForm.dart';
import 'package:to_do_planner/models/habit.dart';
import 'package:to_do_planner/screens/home.dart';

class Edithabits extends StatelessWidget {
  final Habit habit;
  const Edithabits({super.key, required this.habit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 7, 36, 86),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 15, 79, 189),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Home()));
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              )),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20), 
          child: HabitForm(habit: habit)
        )
      );
  }
}
