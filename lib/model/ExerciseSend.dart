class ExerciseSend {
  String name;
  String exerciseGroup;
  String description;
  String createdBy;
  int sequenceOrder;
  String link;

  ExerciseSend({
    required this.name,
    required this.exerciseGroup,
    required this.description,
    required this.createdBy,
    required this.sequenceOrder,
    required this.link,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'exercise_group': exerciseGroup,
    'description': description,
    'created_by': createdBy,
    'sequence_order': sequenceOrder,
    'link': link,
  };
}