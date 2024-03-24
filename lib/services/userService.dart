import 'dart:convert';
import 'package:http/http.dart' as http;

final String _baseUrl = 'http://192.168.0.14:3000/user';

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