class ExerciseModel {
  final String id;
  final String name;
  final String description;
  final String createdBy;

  ExerciseModel({
    this.id = '',
    this.name = '',
    this.description = '',
    this.createdBy = '',
  });

  // fromJson constructor to create an Exercise instance from a map
  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      createdBy: json['createdBy'] ?? '',
    );
  }
}
