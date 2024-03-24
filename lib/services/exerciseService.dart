import 'dart:convert';
import 'package:fitnessapp/model/Exercise.dart';
import 'package:fitnessapp/model/ExerciseGroup.dart';
import 'package:http/http.dart' as http;

const URLEXERCISE = 'http://192.168.0.14:3001/exercise/';
const URLUSER = 'http://192.168.0.14:3000/user';

Future<List<Exercise>> fetchExercisesFromGroupId(String groupId) async {
  String url = URLEXERCISE + 'byGroup?group=$groupId';
  final response = await http
      .get(Uri.parse(url));

  if (response.statusCode == 200) {
    List<dynamic> exercisesJson = json.decode(response.body);
    List<Exercise> exercises =
        exercisesJson.map((json) => Exercise.fromJson(json)).toList();
    return exercises;
  } else {
    throw Exception('Failed to load exercises');
  }
}

Future<List<ExerciseGroup>> fetchExerciseGroups() async {
  var url = Uri.parse(URLEXERCISE + 'group');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<ExerciseGroup> exerciseGroups =
          body.map((json) => ExerciseGroup.fromJson(json)).toList();
      return exerciseGroups;
    } else {
      throw Exception('Failed to load exercise groups');
    }
  } catch (e) {
    throw Exception('Failed to load exercise groups');
  }
}
