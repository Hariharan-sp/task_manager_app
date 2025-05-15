import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/widgets/home_tool_bar.dart';

class WorksheetScreen extends StatelessWidget {
  final String title;
  final String? description;
  final String location;
  final String status;
  final String startTime;
  final String endTime;

  const WorksheetScreen({
    super.key,
    required this.title,
    this.description,
    required this.location,
    required this.status,
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeToolBar(title: "Worksheet",showBackButton: true,),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: Theme.of(context).textTheme.headlineSmall),
                      const SizedBox(height: 8),
                      if (description != null && description!.isNotEmpty)
                        Text(description!, style: TextStyle(color: Colors.grey[700])),
                      const Divider(height: 24),
                      _buildInfoRow(Icons.location_on, 'Location', location),
                      _buildInfoRow(Icons.info_outline, 'Status', status),
                      _buildInfoRow(Icons.access_time, 'Start Time',      DateFormat('d MMM y h:mm a').format(DateTime.parse(startTime)),),
                      _buildInfoRow(Icons.access_time_filled, 'End Time',  DateFormat('d MMM y h:mm a').format(DateTime.parse(endTime))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text('Work Performed', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Describe the work performed...',
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save Worksheet', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.red),
          const SizedBox(width: 10),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
