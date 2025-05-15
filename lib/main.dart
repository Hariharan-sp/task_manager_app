import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/proiders/task_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider()..loadTasks(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp();
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Task Manager',
      home: HomeScreen(),
    );
  }
}
