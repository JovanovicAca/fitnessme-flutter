class ExerciseGroup {
  final String id;
  final String name;
  final String description;

  ExerciseGroup(
      {required this.id, required this.name, required this.description});

  factory ExerciseGroup.fromJson(Map<String, dynamic> json) {
    return ExerciseGroup(
      id: json['id'],
      name: json['group_name'],
      description: json['description'],
    );
  }
}
