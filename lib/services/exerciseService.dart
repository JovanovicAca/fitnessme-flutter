import 'dart:convert';
import 'package:fitnessapp/model/Exercise.dart';
import 'package:fitnessapp/model/ExerciseGroup.dart';
import 'package:fitnessapp/model/ExerciseSend.dart';
import 'package:http/http.dart' as http;

import '../model/ExerciseModel.dart';

const URLEXERCISE = 'http://192.168.0.110:3001/exercise';
const URLUSER = 'http://192.168.0.110:3000/user';
const URLEXERCISEUTP = 'http://192.168.0.101:3001/exercise';
const URLUSERUTP = 'http://192.168.0.101:3000/user';

Future<List<Exercise>> fetchExercisesFromGroupId(String groupId) async {
  String url = URLEXERCISE + '/byGroup?group=$groupId';
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

Future<String> fetchExerciseNameById(String id) async {
  String url = URLEXERCISE + '?id=$id';
  final response = await http
      .get(Uri.parse(url));
  if (response.statusCode == 200) {
    var exerciseJson = json.decode(response.body);
    String exerciseName = exerciseJson['name'];
    return exerciseName;
  } else {
    throw Exception('Failed to load exercise name');
  }
}

Future<List<ExerciseModel>> fetchAllExercises() async {
  var url = Uri.parse(URLEXERCISE + '/all');
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<ExerciseModel> exercises =
      body.map((json) => ExerciseModel.fromJson(json)).toList();
      return exercises;
    } else {
      throw Exception('Failed to load exercise groups');
    }
  } catch (e) {
    throw Exception('Failed to load exercise groups');
  }
}

Future<List<ExerciseGroup>> fetchExerciseGroups() async {
  var url = Uri.parse(URLEXERCISE + '/group');
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

Future<http.Response> saveExercise(Map<String, dynamic> exerciseData, String? token) async{
  String body = json.encode(exerciseData);
  try {
    var response = await http.post(
      Uri.parse(URLEXERCISE),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    return response;
  } catch (e) {
    rethrow;
  }
}

Future<http.Response> saveGroup(Map<String, dynamic> groupData, String? token) async{
  String url = URLEXERCISE + '/group';
  String body = json.encode(groupData);
  try {
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );
    return response;
  } catch (e) {
    rethrow;
  }
}

Future<http.Response> deleteExercise(String id, String token) async{
  var url = '$URLEXERCISE?id=$id';
  try {
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    return response;
  } catch (e) {
    rethrow;
  }
}

Future<http.Response> updateExercise(String id, ExerciseSend exercise, String token) async {
  var url = '$URLEXERCISE?id=$id';
  try{
    final response = await http.put(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(exercise.toJson()),
    );
    return response;
  }catch (e) {
    rethrow;
  }
}

