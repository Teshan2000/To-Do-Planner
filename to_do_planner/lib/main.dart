import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:to_do_planner/models/category.dart';
import 'package:to_do_planner/models/habit.dart';
import 'package:to_do_planner/models/task.dart';
import 'package:to_do_planner/providers/habitProvider.dart';
import 'package:to_do_planner/providers/notificationService.dart';
import 'package:to_do_planner/providers/taskProvider.dart';
import 'package:to_do_planner/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDir.path);
  // await Hive.initFlutter();
  
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await Hive.openBox<Task>('tasks'); 
  await Hive.openBox<Habit>('habits');  

  await NotificationService.initNotification();
  tz.initializeTimeZones();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => TaskProvider()),
    ChangeNotifierProvider(create: (context) => HabitProvider()),
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}
