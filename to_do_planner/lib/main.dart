import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:to_do_planner/providers/habitProvider.dart';
import 'package:to_do_planner/providers/notificationService.dart';
import 'package:to_do_planner/providers/taskProvider.dart';
import 'package:to_do_planner/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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