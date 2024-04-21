class Exercise {
    String id;
    String name;
    String exerciseGroup;
    String description;
    String createdBy;
    int sequenceOrder;
    String link;

  Exercise({
    this.id = '',
    this.name = '',
    this.exerciseGroup = '',
    this.description = '',
    this.createdBy = '',
    this.sequenceOrder = 0,
    this.link = '',
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['Id'] ?? '',
      name: json['Name'] ?? '',
      exerciseGroup: json['ExerciseGroup'] ?? '',
      description: json['Description'] ?? '',
      createdBy: json['CreatedBy'] ?? '',
      sequenceOrder: json['SequenceOrder'] is int
          ? json['SequenceOrder']
          : int.tryParse(json['SequenceOrder']?.toString() ?? '0') ?? 0,
      link: json['Link'] ?? '',
    );
  }

  Exercise copy({
    String? id,
    String? name,
    String? exerciseGroup,
    String? description,
    String? createdBy,
    int? sequenceOrder,
    String? link,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      exerciseGroup: exerciseGroup ?? this.exerciseGroup,
      description: description ?? this.description,
      createdBy: createdBy ?? this.createdBy,
      sequenceOrder: sequenceOrder ?? this.sequenceOrder,
      link: link ?? this.link,
    );
  }

}
