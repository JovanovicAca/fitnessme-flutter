import 'dart:convert';

import 'package:fitnessapp/model/WorkoutFetch.dart';
import 'package:fitnessapp/services/workoutServide.dart';
import 'package:fitnessapp/workoutDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';


class ProgressScreen extends StatefulWidget {
  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}


class _ProgressScreenState extends State<ProgressScreen> {
  List<WorkoutFetch> workouts = [];

  @override
  void initState(){
    super.initState();
    loadWorkouts();
  }

  void loadWorkouts() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt');
    List<WorkoutFetch> allWorkouts = await getWorkouts(token);
    if (mounted) {
      setState((){
        workouts = allWorkouts;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Me'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                'Workout History',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                var workoutFetch = workouts[index];
                String workoutDate = workoutFetch.workouts.isNotEmpty ? DateFormat('yyyy-MM-dd').format(DateTime.parse(workoutFetch.workouts.first.workoutDate)) : "Unknown date";
                return Column(
                  children: [
                    Card(
                      child: ExpansionTile(
                        title: Text('Workout on $workoutDate'),
                        subtitle: Text('Tap on exercise to view details on different screen', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey)),
                        children: workoutFetch.workouts.map((workout) => ListTile(
                          title: Text(workout.exerciseId), // Replace with exercise name when available
                          subtitle: Text('Sets: ${workout.sets}, Reps: ${workout.reps}, Weight: ${workout.weight} kg'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WorkoutDetailScreen(workoutFetch: workoutFetch),
                              ),
                            );
                          },
                        )).toList(),
                      ),
                    ),
                    SizedBox(height: 10), // Add space between the cards
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}