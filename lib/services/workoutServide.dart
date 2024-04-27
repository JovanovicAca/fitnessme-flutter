import 'dart:convert';
import 'package:fitnessapp/model/WorkoutFetch.dart';
import 'package:http/http.dart' as http;

const URLWORKOUTUTP = 'http://192.168.0.101:3002/workout';
const URLWORKOUT = 'http://192.168.0.110:3002/workout';

Future<http.Response> saveWorkout(String data, String? token) async{
  String url = URLWORKOUT;
  try {
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: data,
    );
    print(response.body);
    return response;
  } catch (e) {
    rethrow;
  }
}

Future<List<WorkoutFetch>> getWorkouts(String? token) async{
  try {
    var response = await http.get(
      Uri.parse(URLWORKOUT),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    if (response.statusCode == 200) {
      List<dynamic> workoutJson = json.decode(response.body);
      List<WorkoutFetch> workoutsList = workoutJson.map((json) => WorkoutFetch.fromJson(json)).toList();
      return workoutsList;
    } else {
      throw Exception('Failed to load workouts');
    }
  } catch (e) {
    rethrow;
  }
}