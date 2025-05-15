class TaskModel {
  final int? id;
  final String title;
  final String customer;
  final String location;
  final String status;
  final String scheduledDate;
  final String startTime;
  final String endTime;

  TaskModel({
    this.id,
    required this.title,
    required this.customer,
    required this.location,
    required this.status,
    required this.scheduledDate,
    required this.startTime,
    required this.endTime,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      customer: map['customer'],
      location: map['location'],
      status: map['status'],
      scheduledDate: map['scheduledDate'],
      startTime: map['startTime'],
      endTime: map['endTime'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'customer': customer,
      'location': location,
      'status': status,
      'scheduledDate': scheduledDate,
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
