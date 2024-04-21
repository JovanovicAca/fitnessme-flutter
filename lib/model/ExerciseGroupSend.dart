class ExerciseGroupSend {
  final String name;
  final String description;

  ExerciseGroupSend(
      {required this.name, required this.description});

  Map<String, dynamic> toJson() => {
    'group_name': name,
    'description': description,
  };
}
