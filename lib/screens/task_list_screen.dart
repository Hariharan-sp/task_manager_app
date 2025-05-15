import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../proiders/task_provider.dart';
import '../widgets/home_tool_bar.dart';
import '../models/task.dart';
import 'package:intl/intl.dart';


class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final tasks = provider.openTasks;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F9FB),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HomeToolBar(title:'Tasks',showBackButton: true),
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const Text(
                    'Today ',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    _formattedDate(),
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ],
              ),
            ),
            Expanded(
              child: tasks.isEmpty
                  ? const Center(
                child: Text(
                  'No open tasks.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: tasks.length,
                itemBuilder: (_, index) {
                  final TaskModel task = tasks[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      border: Border(
                        left: BorderSide(
                          color: getStatusColor(task.status),
                          width: 4,
                        ),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${task.location} - ${task.customer}',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Icon(Icons.access_time, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  DateFormat('d MMM y h:mm a').format(DateTime.parse(task.startTime)),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(Icons.swap_horiz_outlined, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  DateFormat('d MMM y h:mm a').format(DateTime.parse(task.endTime)),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.star_border, size: 20, color: Colors.orange),
                              const SizedBox( width: 5),
                              const Icon(Icons.watch_later_outlined, size: 20, color: Colors.grey),
                              const Spacer(),
                              _buildStatusChip(task.status),
                              const SizedBox( width: 5),
                              _buildAvatarsPlaceholder(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final color = getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildAvatarsPlaceholder() {
    return Row(
      children: List.generate(3, (index) {
        return Container(
          margin: const EdgeInsets.only(left: 4),
          child: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, size: 14, color: Colors.white),
          ),
        );
      }),
    );
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      case 'planned':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  String _formattedDate() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = _shortMonth(now.month);
    return '$day $month';
  }
  String _shortMonth(int month) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return months[(month - 1) % 12];
  }
}
