import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/WorkoutFetch.dart';

class WorkoutDetailScreen extends StatelessWidget {
  final WorkoutFetch workoutFetch;

  const WorkoutDetailScreen({Key? key, required this.workoutFetch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout on ${DateFormat('yyyy-MM-dd').format(DateTime.parse(workoutFetch.workouts.first.workoutDate))}'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: workoutFetch.workouts.length,
        itemBuilder: (context, index) {
          var workout = workoutFetch.workouts[index];
          return ListTile(
            title: Text(workout.exerciseId),
            subtitle: Text('Sets: ${workout.sets}, Reps: ${workout.reps}, Weight: ${workout.weight} kg'),
            leading: Icon(Icons.fitness_center, color: Colors.blue),
          );
        },
      ),
    );
  }
}