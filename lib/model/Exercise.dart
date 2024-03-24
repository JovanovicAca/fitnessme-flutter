class Exercise {
  final String id;
  final String name;
  final List<String> exerciseGroup;
  final String description;
  final String createdBy;
  final int sequenceOrder;
  final String link;

  Exercise({
    this.id = '',
    this.name = '',
    this.exerciseGroup = const [],
    this.description = '',
    this.createdBy = '',
    this.sequenceOrder = 0,
    this.link = '',
  });

  // fromJson constructor to create an Exercise instance from a map
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['Id'] ?? '',
      name: json['Name'] ?? '',
      exerciseGroup: List<String>.from(json['exerciseGroup'] ?? []),
      description: json['Description'] ?? '',
      createdBy: json['CreatedBy'] ?? '',
      sequenceOrder: json['SequenceOrder'] is int
          ? json['SequenceOrder']
          : int.tryParse(json['SequenceOrder']?.toString() ?? '0') ?? 0,
      link: json['Link'] ?? '',
    );
  }
}
