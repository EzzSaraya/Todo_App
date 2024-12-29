class Task {
  static const String collectionName = 'Tasks';
  String title;

  String description;
  String id;
  DateTime dateTime;
  bool isDone;

  Task(
      {this.id = '',
      required this.description,
      required this.title,
      required this.dateTime,
      this.isDone = false});

  Map<String, dynamic> toFireStore() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.millisecondsSinceEpoch,
      'isDone': isDone
    };
  }

  Task.fromFireStore(Map<String, dynamic> data)
      : this(
            id: data['id'] as String,
            title: data['title'] as String,
            description: data['description'] as String,
            dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
            isDone: data['isDone'] as bool);
}
