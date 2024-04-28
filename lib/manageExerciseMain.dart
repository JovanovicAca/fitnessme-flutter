import 'package:fitnessapp/exerciseCard.dart';
import 'package:fitnessapp/model/Exercise.dart';
import 'package:fitnessapp/model/ExerciseGroup.dart';
import 'package:fitnessapp/model/ExerciseSend.dart';
import 'package:fitnessapp/services/exerciseService.dart';
import 'package:fitnessapp/utils/jwt.dart';
import 'package:fitnessapp/utils/methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'addGroupDialog.dart';
import 'addNewExercise.dart';
import 'navigationBottom.dart';

class ManageExerciseMain extends StatefulWidget {
  const ManageExerciseMain({super.key});

  @override
  State<ManageExerciseMain> createState() => _ManageExerciseMainState();
}

class _ManageExerciseMainState extends State<ManageExerciseMain> {
  bool isAdmin = false;
  String? selectedGroup;
  String? selectedGroupId;
  List<ExerciseGroup> exerciseGroups = [];
  List<Exercise>? exercises;

  @override
  void initState() {
    super.initState();
    checkAdminStatus();
    loadExerciseGroups();
  }

  void _deleteExercise(String exerciseId) async{
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt');
    var response = await deleteExercise(exerciseId, token!);
    if (response.statusCode == 204) {
      List<Exercise>? exercises =
      await fetchExercisesFromGroupId(selectedGroupId!);
      setState(() {
        this.exercises = exercises;
      });
    } else {
      print('Failed to delete exercise. Status code: ${response.statusCode}');
    }
  }

  void _editExercise(Exercise exercise) async{
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt');
    var exerciseSend = ExerciseSend(name: exercise.name, exerciseGroup: exercise.exerciseGroup, description: exercise.description, createdBy: exercise.createdBy, sequenceOrder: exercise.sequenceOrder, link: exercise.link);
    var response = await updateExercise(exercise.id, exerciseSend, token!);
    if (response.statusCode == 204) {
      List<Exercise>? exercises =
      await fetchExercisesFromGroupId(selectedGroupId!);
      setState(() {
        this.exercises = exercises;
        loadExerciseGroups();
      });
    } else {
      print('${response.body}: ${response.statusCode}');
    }
  }


  void checkAdminStatus() async{
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt');
    bool newIsAdmin = getUserRoleFromToken(token) == 'admin';
    if (newIsAdmin != isAdmin) {
      setState(() {
        isAdmin = newIsAdmin;
      });
    }
  }

  void refreshData() async {
    loadExerciseGroups();
    setState(() {});
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Exercise Management',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton<String>(
                    value: selectedGroup,
                    hint: const Text('Select Group'),
                    items: exerciseGroups
                        .map<DropdownMenuItem<String>>((ExerciseGroup group) {
                      return DropdownMenuItem<String>(
                        value: group.name,
                        child: Text(group.name),
                      );
                    }).toList(),
                    onChanged: (String? newValue) async {
                      if (newValue == null) return;
                      try {
                        setState(() {
                          selectedGroup = newValue;
                          selectedGroupId = getIdFromName(newValue, exerciseGroups);
                        });
                        List<Exercise>? exercises =
                            await fetchExercisesFromGroupId(selectedGroupId!);
                        setState(() {
                          this.exercises = exercises;
                        });
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                  const SizedBox(height: 100),
                  if (isAdmin)
                    ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AddGroupDialog(onSuccess: refreshData);
                          },
                        );
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Add new group'),
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          textStyle: const TextStyle(fontSize: 14),
                          backgroundColor: Colors.lightBlueAccent),
                    ),
                ],
              ),

              const SizedBox(height: 20),
              ExercisesListWidget(exercises: exercises ?? [], isAdmin: isAdmin, onDelete: _deleteExercise, onEdit: _editExercise, exerciseGroups: exerciseGroups),
              if (isAdmin) ...[
                const SizedBox(height: 50),
                Text(
                  'Create new exercise',
                  style: Theme.of(context).textTheme.headline5,
                ),
                AddExerciseWidget(exerciseGroups: exerciseGroups ?? []),
              ],
            ]
          ),
        ),
      ),
    );
  }
}
