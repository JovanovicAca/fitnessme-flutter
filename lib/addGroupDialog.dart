import 'package:fitnessapp/model/ExerciseGroup.dart';
import 'package:fitnessapp/services/exerciseService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'model/ExerciseGroupSend.dart';

class AddGroupDialog extends StatefulWidget {
  final Function onSuccess;

  const AddGroupDialog({Key? key, required this.onSuccess}) : super(key: key);

  @override
  _AddGroupDialogState createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  final _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  String groupName = '';
  String groupDescription = '';
  String? responseMessage;
  bool? _isSuccess;

  Future<void> submitGroup() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isSubmitting = true;
      });
    }

    if (_formKey.currentState?.validate() == true) {
      try{
        const storage = FlutterSecureStorage();
        String? token = await storage.read(key: 'jwt');
        ExerciseGroupSend group = ExerciseGroupSend(
            name: groupName, description: groupDescription);
        var response = await saveGroup(group.toJson(), token);
        isSubmitting = false;
        if (mounted) {
          setState(() {
            isSubmitting = false;
            if (response.statusCode == 201) {
              responseMessage = 'Group added successfully!';
              _isSuccess = true;
              widget.onSuccess();
            } else if (response.statusCode == 409) {
              responseMessage = response.body;
              _isSuccess = false;
            }
          });
        }}
      catch (e){
        setState(() {
          responseMessage = 'An error occurred';
          _isSuccess = false;
        });
       }finally {
        setState(() {
          isSubmitting = false;
        });
      }
      }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Add New Exercise Group',
        style: TextStyle(fontSize: 20), // Adjust the font size as needed
      ),
      content: isSubmitting
          ? const CircularProgressIndicator()
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (responseMessage != null)
            Column(
              children: [
                Icon(
                  _isSuccess == true ? Icons.check_circle : Icons.error,
                  color: _isSuccess == true ? Colors.green : Colors.red,
                  size: 60,
                ),
                Text(responseMessage!, textAlign: TextAlign.center),
              ],
            )
          else
            Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Group Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a group name';
                      }
                      return null;
                    },
                    onSaved: (value) => groupName = value ?? '',
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                    onSaved: (value) => groupDescription = value ?? '',
                  ),
                ],
              ),
            ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: isSubmitting ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        if (!isSubmitting && responseMessage == null)
          ElevatedButton(
            onPressed: isSubmitting ? null : submitGroup,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) {
                  if (states.contains(MaterialState.pressed)) return Colors.blue.shade900;
                  return Colors.lightBlue; // Use the component's default.
                },
              ),
            ),
            child: const Text('Submit'),
          ),
      ],
    );
  }
}
