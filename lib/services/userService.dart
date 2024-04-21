import 'dart:convert';
import 'package:fitnessapp/model/User.dart';
import 'package:fitnessapp/model/UserUpdate.dart';
import 'package:http/http.dart' as http;

import '../model/UserReceive.dart';

final String _baseUrl = 'http://192.168.0.14:3000/user';
final String _baseUrlUTP = 'http://192.168.0.101:3000/user';

Future<http.Response> registerUser(Map<String, dynamic> userData) async {
  String url = '$_baseUrl/register';
  String body = json.encode(userData);

  var response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );
  return response;
}

Future<User> getUser(String token) async {
  String url = '$_baseUrl';
  var response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      }
  );
  if (response.statusCode == 200) {
    dynamic body = jsonDecode(response.body);
    User user = User.fromJson(body);
    return user;
  } else{
    throw Exception('Failed to load user');
  }
}

Future<http.Response> updateUser(Map<String, dynamic> user, String token) async {
  try{
    String requestBody = jsonEncode(user);
    var response = await http.patch(
      Uri.parse(_baseUrl),
      headers: {
        "Authorization": "Bearer $token",
      },
      body: requestBody
    );
    return response;
  }
  catch (e) {
    print('Exception while updating user: $e');
    rethrow; // Rethrow the exception
  }
}

Future<List<UserReceive>> fetchAllAdmins() async {
  var url = Uri.parse(_baseUrl + "/admins");
  try {
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<UserReceive> admins =
      body.map((json) => UserReceive.fromJson(json)).toList();
    return admins;
    }else{
      throw Exception('Failed to load admins');
    }
  }catch (e) {
      throw Exception('Failed to load admins');
  }
}