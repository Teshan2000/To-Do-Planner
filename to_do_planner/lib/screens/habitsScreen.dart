import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_planner/providers/taskProvider.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 36, 86),
      appBar: AppBar(
        title: const Text(
          "Habits",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 15, 79, 189),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, habitProvider, _) {
          return ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return const ListTile(
                title: Text(
                  "Book Reading",
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                ),
                subtitle: Text("Streak: 5 days",
                    style: TextStyle(color: Color.fromARGB(255, 103, 153, 239))),
                trailing: Icon(
                  Icons.menu_book,
                  color: Colors.white,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 15, 79, 189),
        onPressed: () {},
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
