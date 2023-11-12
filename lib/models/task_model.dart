class TaskModel {
  final String id;
  final String text;

  TaskModel({
    required this.id,
    required this.text,
  });

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      text: map['text'] as String,
      id: map['_id'] as String,
    );
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      text: json['text'] as String,
      id: json['_id'] as String,
    );
  }
}
