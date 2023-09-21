class Task {
  final int? id;
  final String name;
  final String startTime;

  Task({
    this.id,
    required this.name,
    required this.startTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'startTime': startTime,
    };
  }
}