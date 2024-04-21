import 'package:fitnessapp/model/ExerciseSend.dart';
import 'package:fitnessapp/services/exerciseService.dart';
import 'package:fitnessapp/utils/jwt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'model/Exercise.dart';
import 'model/ExerciseGroup.dart';

class AddExerciseWidget extends StatefulWidget {
  final List<ExerciseGroup> exerciseGroups;

  const AddExerciseWidget({Key? key, required this.exerciseGroups})
      : super(key: key);

  @override
  _AddExerciseWidgetState createState() => _AddExerciseWidgetState();
}

class _AddExerciseWidgetState extends State<AddExerciseWidget> {
  final _formKey = GlobalKey<FormState>();
  String? selectedGroup;
  String name = '';
  String description = '';
  int sequenceOrder = 0;
  String link = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Exercise Name'),
                onSaved: (value) => name = value ?? '',
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedGroup,
                decoration: const InputDecoration(labelText: 'Exercise Group'),
                items: widget.exerciseGroups.map((ExerciseGroup group) {
                  return DropdownMenuItem<String>(
                    value: group.id,
                    child: Text(group.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedGroup = value),
                validator: (value) => value == null ? 'Please select a group' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                onSaved: (value) => description = value ?? '',
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Sequence Order'),
                keyboardType: TextInputType.number,
                onSaved: (value) => sequenceOrder = int.parse(value ?? '0'),
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Link'),
                onSaved: (value) => link = value ?? '',
                validator: (value) => value!.isEmpty ? 'Please enter a link' : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        final storage = FlutterSecureStorage();
                        String? token = await storage.read(key: 'jwt');
                        String userId = getUserIdFromToken(token);
                        ExerciseSend exercise = ExerciseSend(
                          name: name,
                          exerciseGroup: selectedGroup ?? '',
                          description: description,
                          createdBy: userId,
                          sequenceOrder: sequenceOrder,
                          link: link,
                        );
                        try {
                          var response = await saveExercise(exercise.toJson(), token);
                          if(mounted){
                            if (response.statusCode == 201) {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Success'),
                                    content: const Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.check_circle, color: Colors.green, size:100),
                                        SizedBox(width: 30),
                                        Text('Exercise saved successfully.', textAlign: TextAlign.center),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.error, color: Colors.red, size: 100),
                                        SizedBox(height: 30),
                                        Text(response.body, textAlign: TextAlign.center),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(); // Close the dialog
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          }
                        } catch (e) {
                          print('An error occurred while saving the exercise: $e');
                        }
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}