import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/screens/task_form.dart';
import 'package:task_manager/screens/task_list_screen.dart';
import 'package:task_manager/screens/work_sheet.dart';

import '../proiders/task_provider.dart';
import '../widgets/home_tool_bar.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final openCount = provider.openTasks.length;
    final completedCount = provider.completedCount;
    final activeTask = provider.getActiveTask();

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeToolBar(title: 'Home',),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.wb_sunny, color: Colors.grey, size: 28),
                Text(
                  _formattedDate(),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Overview',
                    style:
                    TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.refresh_rounded, color: Colors.grey, size: 18),
                    Text('Updated 20 min ago',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _overviewCard(
                  label: 'Task',
                  count: openCount,
                  icon: Icons.folder,
                  iconColor: Colors.white,
                  backgroundColor: Colors.blue,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const TaskListScreen()),
                    );
                  },
                ),
                const SizedBox(width: 12),
                _overviewCard(
                  label: 'Completed Tasks',
                  count: completedCount,
                  icon: Icons.task,
                  iconColor: Colors.white,
                  backgroundColor: Colors.blue.shade200,
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (activeTask != null)
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            activeTask.title,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          GestureDetector(
                            onTap: () {
                              provider.updateTaskStatus(
                                  activeTask.id.toString(),
                                  'Closed'
                              );
                            },
                            child: const Text(
                              'Close',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activeTask.location,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(DateTime.parse(activeTask.startTime)),
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.orange, size: 16),
                          const SizedBox(width: 4),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            child: Text(
                              activeTask.status,
                              style: const TextStyle(
                                  color: Colors.blueAccent, fontSize: 12),
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.access_time,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('h:mm a')
                                .format(DateTime.parse(activeTask.startTime)),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 8),
                          const CircleAvatar(
                            radius: 12,
                            backgroundImage: AssetImage(
                                'assets/images/avatar.png'),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Buttons with implemented logic
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Start task logic
                                provider.updateTaskStatus(
                                    activeTask.id.toString(),
                                    'In Progress'
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Task started'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.play_arrow),
                              label: const Text(
                                'Start',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => WorksheetScreen(
                                      title: activeTask.title,
                                    //  description: activeTask.description,
                                      location: activeTask.location,
                                      status: activeTask.status,
                                      startTime: activeTask.startTime,
                                      endTime: activeTask.endTime,
                                    ),
                                  ),
                                );
                              },


                              icon: const Icon(Icons.insert_drive_file_outlined),
                              label: const Text(
                                'Worksheet',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade100,
                                foregroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                            
                              
                              },
                              icon: const Icon(Icons.add),
                              label: const Text(
                                'Add Time',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade100,
                                foregroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("Add New Task"),
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TaskFormScreen(),
                  ),
                );
              },
              backgroundColor: Colors.grey,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _overviewCard({
    required String label,
    required int count,
    IconData? icon,
    Color? iconColor,
    Color? backgroundColor,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.blue, // default to blue
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Icon(icon, size: 50, color: iconColor ?? Colors.grey),
                      ],
                    ),
                  ),
                const SizedBox(height: 8),
                Text(label,
                    style: const TextStyle(fontSize: 18, color: Colors.white)),
                const SizedBox(height: 4),
                Text(
                  '$count',
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Updated Few Minutes Ago',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();
    final weekday = _shortWeekday(now.weekday);
    final day = now.day.toString().padLeft(2, '0');
    final month = _shortMonth(now.month);
    return '$weekday $day $month';
  }

  String _shortWeekday(int weekday) {
    const days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return days[(weekday - 1) % 7];
  }

  String _shortMonth(int month) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC'
    ];
    return months[(month - 1) % 12];
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = _shortMonth(date.month);
    final year = date.year.toString();
    return '$month $day, $year';
  }
}