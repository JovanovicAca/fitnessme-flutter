import 'dart:convert';

import 'package:fitnessapp/model/AdminChatReceive.dart';
import 'package:fitnessapp/model/Message.dart';
import 'package:http/http.dart' as http;

final String _baseUrl = 'http://192.168.0.110:3003/chat';

Future<String?> getChat(String user1, String user2) async {
  final Uri uri = Uri.parse('$_baseUrl?user1=$user1&user2=$user2');

  try {
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['chat_id'];
    } else {
      return null;
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}

Future<http.Response> saveChat(Map<String, dynamic> chatData) async {
  String body = json.encode(chatData);
  try{
    var response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    return response;
  } catch (e) {
    rethrow;
  }
}

Future<List<Message>> getMessagesFromChat(String chatId) async {
  try{
    var response = await http.get(
      Uri.parse('$_baseUrl/messages?chatid=$chatId')
    );
    if (response.statusCode == 200){
      List<dynamic> messagesJson = json.decode(response.body);
      List<Message> messageList = messagesJson.map((json) => Message.fromJson(json)).toList();
      return messageList;
    }else{
      throw Exception('Failed to load messages');
    }
  } catch (e) {
    rethrow;
  }
}

Future<int> getUnreadMessageCountForAdmin(String userid, String adminid) async {
  String url = _baseUrl + '/unread?user1=$userid&user2=$adminid';
  final response = await http
        .get(Uri.parse(url));
  if(response.statusCode == 200) {
    var unreadJson = json.decode(response.body);
    int unread = unreadJson['unread'];
    return unread;
  }else{
    throw Exception('Failed to load unread messages');
  }
}

Future<http.Response> markMessagesRead(Map<String, dynamic> chatData) async {
  var url = '$_baseUrl/readAll';
  String body = json.encode(chatData);
  try{
    var response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    return response;
  } catch (e) {
    rethrow;
  }
}

Future<List<AdminChatReceive>> fetchNewAdminChats(String id) async {
  var url = Uri.parse(_baseUrl + '/new_chats?id=$id');
  try{
    var response = await http.get(url);
    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(response.body);
      List<AdminChatReceive> chatUsers = body.map((json) => AdminChatReceive.fromJson(json)).toList();
      return chatUsers;
    }else{
      throw Exception('Failed to get chat users');
    }
  }catch (e) {
    throw Exception('Failed to get chat users');
  }
}