import 'package:fitnessapp/model/Workout.dart';

class WorkoutFetch {
  final String workoutId;
  final List<Workout> workouts;

  WorkoutFetch({required this.workoutId, required this.workouts});

  factory WorkoutFetch.fromJson(Map<String, dynamic> json) {
    var list = json['Exercises'] as List;
    List<Workout> workoutList = list.map((i) => Workout.fromJson(i)).toList();

    return WorkoutFetch(
      workoutId: json['WorkoutID'],
      workouts: workoutList,
    );
  }
}