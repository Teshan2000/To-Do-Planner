import 'package:flutter/material.dart';
import 'package:to_do_planner/components/taskForm.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 7, 36, 86),
      appBar: AppBar(
        title: const Text(
          "To Do Planner",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 15, 79, 189),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 250,
            child: ListView.separated(
              itemBuilder: (context, index) {
                return const ListTile(
                  title: Text(
                    "Doctor Checkup",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  subtitle: Text(
                    "Tomorrow, 12:39",
                    style: TextStyle(color: Color.fromARGB(255, 15, 79, 189)),
                  ),
                );
              },
              itemCount: 3,
              separatorBuilder: (context, index) {
                return const Divider(
                  color: Colors.white,
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 15, 79, 189),
        onPressed: () async {
          showDialog(
            context: context, 
            builder: (_) => Padding(
              padding: const EdgeInsets.all(10),
              child: Dialog(
                backgroundColor: const Color.fromARGB(255, 15, 79, 189),
                insetPadding: const EdgeInsets.all(10),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        height: 490,
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(25, 30, 25, 25),
                        child: const TaskForm(),
                      ),
                    ),
                  ]
                ),
              ),
            )
          );
        },
        shape: const CircleBorder(side: BorderSide.none),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
