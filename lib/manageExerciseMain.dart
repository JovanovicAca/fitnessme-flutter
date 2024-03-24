import 'package:fitnessapp/exerciseCard.dart';
import 'package:fitnessapp/model/Exercise.dart';
import 'package:fitnessapp/model/ExerciseGroup.dart';
import 'package:fitnessapp/services/exerciseService.dart';
import 'package:flutter/material.dart';

import 'navigationBottom.dart';

class ManageExerciseMain extends StatefulWidget {
  const ManageExerciseMain({super.key});

  @override
  State<ManageExerciseMain> createState() => _ManageExerciseMainState();
}

class _ManageExerciseMainState extends State<ManageExerciseMain> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedGroup;
  String? selectedGroupId;
  List<ExerciseGroup> exerciseGroups = [];
  String? exerciseName;
  String? description;
  int? sequenceOrder;
  String? videoLink;
  List<Exercise>? exercises;

  @override
  void initState() {
    super.initState();
    loadExerciseGroups();
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Select Exercise Group',
                style: Theme.of(context).textTheme.headline4,
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
                          selectedGroupId = getIdFromName(newValue);
                        });
                        List<Exercise> exercises =
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
                  ElevatedButton.icon(
                    onPressed: () {
                      // Logic to add a new exercise group
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
              ExercisesListWidget(exercises: exercises ?? []),
              // Form(
              //   key: _formKey,
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: <Widget>[
              //       TextFormField(
              //         decoration: const InputDecoration(
              //           labelText: 'Exercise Name',
              //         ),
              //         onSaved: (value) {
              //           exerciseName = value;
              //         },
              //         validator: (value) {
              //           if (value == null || value.isEmpty) {
              //             return 'Please enter exercise name';
              //           }
              //           return null;
              //         },
              //       ),
              //       TextFormField(
              //         decoration: const InputDecoration(
              //           labelText: 'Description',
              //         ),
              //         onSaved: (value) {
              //           description = value;
              //         },
              //         validator: (value) {
              //           if (value == null || value.isEmpty) {
              //             return 'Please enter a description';
              //           }
              //           return null;
              //         },
              //       ),
              //       TextFormField(
              //         decoration: const InputDecoration(
              //           labelText: 'Sequence Order',
              //         ),
              //         keyboardType: TextInputType.number,
              //         onSaved: (value) {
              //           sequenceOrder = int.tryParse(value ?? '');
              //         },
              //         validator: (value) {
              //           if (value == null ||
              //               value.isEmpty ||
              //               int.tryParse(value) == null) {
              //             return 'Please enter a valid sequence order';
              //           }
              //           return null;
              //         },
              //       ),
              //       TextFormField(
              //         decoration: const InputDecoration(
              //           labelText: 'Video Link',
              //         ),
              //         onSaved: (value) {
              //           videoLink = value;
              //         },
              //         validator: (value) {
              //           if (value == null || value.isEmpty) {
              //             return 'Please enter a video link';
              //           }
              //           return null;
              //         },
              //       ),
              //       const SizedBox(height: 20),
              //       Center(
              //         child: ElevatedButton(
              //           onPressed: () {
              //             if (_formKey.currentState!.validate()) {
              //               _formKey.currentState!.save();
              //             }
              //           },
              //           child: const Text('Submit Exercise'),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: NavigationBottom(),
    );
  }

  String? getIdFromName(String? selectedGroup) {
    for (final e in exerciseGroups) {
      if (e.name == selectedGroup) {
        return e.id;
      }
    }
    return null;
  }
}
