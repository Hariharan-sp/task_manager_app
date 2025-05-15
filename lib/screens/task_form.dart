import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/widgets/home_tool_bar.dart';
import '../models/task.dart';
import '../proiders/task_provider.dart';

class TaskFormScreen extends StatefulWidget {
  final TaskModel? task;

  const TaskFormScreen({super.key, this.task});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String selectedStatus = 'New'; // default
  final List<String> statuses = ['New', 'Planned', 'In Progress'];

  late String _title;
  late String _customer;
  late String _location;
  late String _scheduledDate;
  DateTime? _startDate;
  TimeOfDay? _startTime;
  DateTime? _endDate;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    _title = widget.task?.title ?? '';
    _customer = widget.task?.customer ?? '';
    _location = widget.task?.location ?? '';
    _scheduledDate = widget.task?.scheduledDate ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const HomeToolBar(title: 'Tasks',showBackButton: true,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: ToggleButtons(
                isSelected: statuses.map((s) => s == selectedStatus).toList(),
                onPressed: (index) {
                  setState(() {
                    selectedStatus = statuses[index];
                  });
                },
                children: statuses
                    .map((status) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: selectedStatus == status
                          ? Colors.white
                          : Colors.blue,
                    ),
                  ),
                ))
                    .toList(),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Assignees
                      const Text(
                        "Assignees",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(3, (index) {
                          return const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: CircleAvatar(backgroundColor: Colors.grey),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),


                      _buildTextFormField(
                        label: 'Customer',
                        initialValue: _customer,
                        onSaved: (val) => _customer = val ?? '',
                      ),
                      const SizedBox(height: 8),
                      _buildTextFormField(
                        label: 'Location',
                        initialValue: _location,
                        onSaved: (val) => _location = val ?? '',
                      ),
                      const SizedBox(height: 8),


                      _buildDateTimePicker(
                        label: 'Start Date',
                        date: _startDate,
                        onTap: () => _pickDate(context, true),
                      ),
                      _buildDateTimePicker(
                        label: 'Start Time',
                        time: _startTime,
                        onTap: () => _pickTime(context, true),
                      ),
                      _buildDateTimePicker(
                        label: 'End Date',
                        date: _endDate,
                        onTap: () => _pickDate(context, false),
                      ),
                      _buildDateTimePicker(
                        label: 'End Time',
                        time: _endTime,
                        onTap: () => _pickTime(context, false),
                      ),

                      const SizedBox(height: 16),
                      const Text("Allocated Time: 24:00 Hrs"),

                      const SizedBox(height: 16),

                      // Tabs Section
                      const DefaultTabController(
                        length: 3,
                        child: Column(
                          children: [
                            TabBar(
                              tabs: [
                                Tab(text: "Description"),
                                Tab(text: "Equipment"),
                                Tab(text: "Vehicles"),
                              ],
                            ),
                            SizedBox(
                              height: 150,
                              child: TabBarView(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text("Add details about this task..."),
                                  ),
                                  Center(child: Text("No equipment")),
                                  Center(child: Text("No vehicles")),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.navigation),
                              label: const Text("Start Travel"),
                              style: ElevatedButton.styleFrom(
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (_formKey.currentState?.validate() ?? false) {
                                  _formKey.currentState?.save();


                                  if (_startDate == null || _startTime == null || _endDate == null || _endTime == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Please select start and end date/time')),
                                    );
                                    return;
                                  }

                                  final String formattedStart = formatDateTime(_startDate!, _startTime!);
                                  final String formattedEnd = formatDateTime(_endDate!, _endTime!);

                                  final newTask = TaskModel(
                                    title: _title,
                                    customer: _customer,
                                    location: _location,
                                    status: selectedStatus,
                                    scheduledDate: _scheduledDate,
                                    startTime: formattedStart,
                                    endTime: formattedEnd,
                                  );

                                  await provider.addTask(newTask);
                                  Navigator.pop(context);
                                }
                              },
                              icon: const Icon(Icons.check),
                              label: const Text("Start Task"),
                              style: ElevatedButton.styleFrom(
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDateTime(DateTime date, TimeOfDay time) {
    final dt = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    return dt.toIso8601String(); // You can customize format if needed
  }

  Widget _buildTextFormField({
    required String label,
    required String initialValue,
    required FormFieldSetter<String> onSaved,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      onSaved: onSaved,
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
    );
  }

  Widget _buildDateTimePicker({
    required String label,
    DateTime? date,
    TimeOfDay? time,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        date != null
            ? '$label: ${date.toLocal().toString().split(' ')[0]}'
            : time != null
            ? '$label: ${time.format(context)}'
            : 'Select $label',
      ),
      trailing: const Icon(Icons.calendar_today),
      onTap: onTap,
    );
  }

  Future<void> _pickDate(BuildContext context, bool isStartDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  Future<void> _pickTime(BuildContext context, bool isStartTime) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }
}
