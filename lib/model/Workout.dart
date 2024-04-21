import 'dart:convert';

class Workout {
  String userId;
  String exerciseId;
  String workoutDate;
  int sets;
  int reps;
  double weight;
  double duration;

  Workout({
    required this.userId,
    required this.exerciseId,
    required this.workoutDate,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.duration,
  });


  Map<String, dynamic> toMap(String userId, double duration) {
    return {
      'userId': userId,
      'exerciseId': exerciseId,
      'workoutDate': workoutDate, // Converting DateTime to a string format
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'duration': duration,
    };
  }

  static String toJson(List<Workout> workouts, String userId, double duration) {
    List<Map<String, dynamic>> workoutMaps = workouts.map((workout) => workout.toMap(userId, duration)).toList();
    return jsonEncode(workoutMaps);
  }

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      userId: json['UserId'],
      exerciseId: json['Exercise'],
      workoutDate: json['WorkoutDate'],
      sets: json['Sets'],
      reps: json['Reps'],
      weight: json['Weight'].toDouble(),
      duration: json['Duration'].toDouble(),
    );
  }
}
