import 'package:fitnessapp/services/exerciseService.dart';
import 'package:fitnessapp/services/workoutServide.dart';
import 'package:fitnessapp/utils/jwt.dart';
import 'package:fitnessapp/utils/methods.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'model/Exercise.dart';
import 'model/ExerciseGroup.dart';
import 'model/ExerciseModel.dart';
import 'model/Workout.dart';
import 'package:fitnessapp/utils/methods.dart';

class CreateWorkoutScreen extends StatefulWidget {
  @override
  _CreateWorkoutScreenState createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  final List<Workout> workouts = [];
  List<ExerciseGroup> exerciseGroups = [];
  final _formKey = GlobalKey<FormState>();
  int sets = 0;
  int reps = 0;
  double weight = 0.0;
  double duration = 0.0;
  String selectedGroupId = "";
  String selectedGroup = "";
  String selectedExercise = "";
  String selectedExerciseId = "";
  String workoutExercise = "";
  List<Exercise> exercises = [];
  List<ExerciseModel> allExercises = [];
  String userId = "";

  void _addWorkout() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        workouts.add(
          Workout(
            userId: userId,
            exerciseId: selectedExerciseId, // Should be updated with actual ID
            workoutDate: DateTime.now().toIso8601String().split('T').first,
            sets: sets,
            reps: reps,
            weight: weight,
            duration: duration,
          ),
        );
      });
    }
  }

  void _saveWorkouts(double duration) async {
    print('Saving workouts...');
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt');
    String userId = getUserIdFromToken(token);
    var response = await saveWorkout(Workout.toJson(workouts, userId, duration), token);
    if (response.statusCode == 201){
      _showSuccessSnackBar(context);
    }
    else{
      _showErrorSnackBar(context);
    }
  }

  @override
  void initState() {
    super.initState();
    loadExerciseGroups();
    loadAllExercises();
  }

  void refreshData() async {
    loadExerciseGroups();
    loadAllExercises();
    setState(() {});
  }

  void loadAllExercises() async {
    try {
      List<ExerciseModel> exercises = await fetchAllExercises();
      if (mounted) {
        setState(() {
          allExercises = exercises;
        });
      }
    } catch (e) {
      print('Failed to load exercise groups: $e');
    }
  }

  void loadExerciseGroups() async {
    try {
      List<ExerciseGroup> groups = await fetchExerciseGroups();
      if (mounted) {
        setState(() {
          exerciseGroups = groups;
        });
      }
    } catch (e) {
      print('Failed to load exercise groups: $e');
    }
  }

  void _showSuccessSnackBar(BuildContext context) {
    const snackBar = SnackBar(
      content: Row(
        children: <Widget>[
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 20),
          Text("Workout saved successfully!"),
        ],
      ),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showErrorSnackBar(BuildContext context) {
    const snackBar = SnackBar(
      content: Row(
        children: <Widget>[
          Icon(Icons.error_outline, color: Colors.red),
          SizedBox(width: 20),
          Text("Workout saving error!"),
        ],
      ),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<String>(
                        value: selectedGroupId.isNotEmpty ? selectedGroupId : null,
                        hint: const Text('Select Exercise Group'),
                        items: exerciseGroups.map<DropdownMenuItem<String>>((ExerciseGroup group) {
                          return DropdownMenuItem<String>(
                            value: group.id,
                            child: Text(group.name),
                          );
                        }).toList(),
                        onChanged: (String? newValue) async {
                          if (newValue == null) return;
                          try {
                            setState(() {
                              selectedGroupId = newValue;
                            });
                            List<Exercise> exercises =
                            await fetchExercisesFromGroupId(selectedGroupId);
                            setState(() {
                              this.exercises = exercises!;
                              selectedExerciseId = (exercises.isNotEmpty ? exercises.first.id : null)!;
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                      ),
                      if (exercises.isNotEmpty)
                        DropdownButton<String>(
                          value: selectedExerciseId.isNotEmpty ? selectedExerciseId : null,
                          hint: const Text('Select Exercise'),
                          items: exercises.map<DropdownMenuItem<String>>((
                              Exercise exercise) {
                            return DropdownMenuItem<String>(
                              value: exercise.id,
                              child: Text(exercise.name),
                            );
                          }).toList(),
                          onChanged: (String? newValue) async{
                            setState((){
                              selectedExerciseId = newValue ?? '';
                            });
                          },
                        ),

                      TextFormField(
                        decoration: InputDecoration(labelText: 'Sets'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter sets';
                          }
                          return null;
                        },
                        onSaved: (value) => sets = int.parse(value ?? '0'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Reps'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter reps';
                          }
                          return null;
                        },
                        onSaved: (value) => reps = int.parse(value ?? '0'),
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Weight'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter weight';
                          }
                          return null;
                        },
                        onSaved: (value) => weight = double.parse(value ?? '0.0'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: ElevatedButton(
                            onPressed: _addWorkout,
                            child: Text("Add Exercise to Workout"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ...workouts.map((workout) {
              int index = workouts.indexOf(workout);
              return ListTile(
                title: Text("Sets: ${workout.sets}, Reps: ${workout.reps}, Weight: ${workout.weight}"),
                trailing: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    // Remove the workout from the list
                    setState(() {
                      workouts.removeAt(index);
                    });
                  },
                ),
              );
            }).toList(),
            ElevatedButton(
              // onPressed: _saveWorkouts,
              onPressed: () => _showDurationDialog(context),
              child: Text("Save Workouts"),
            ),
          ],
        )
      ),
    );
  }
  Future<void> _showDurationDialog(BuildContext context) async {
    final TextEditingController controller = TextEditingController();

    final value = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Workout Duration'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(hintText: "Enter duration in minutes"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );

    if (value != null) {
      double? duration = double.tryParse(value); // Convert the input to a double
      if (duration != null) {
        // You can now use the duration value for further processing
        _saveWorkouts(duration); // Call _saveWorkouts with the duration
      } else {
        // Handle invalid input
        print("Invalid input for duration");
      }
    }
  }
}
