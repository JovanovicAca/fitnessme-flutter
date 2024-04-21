import 'package:fitnessapp/model/UserReceive.dart';
import 'package:fitnessapp/services/chatService.dart';
import 'package:fitnessapp/services/userService.dart';
import 'package:fitnessapp/utils/jwt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ChatScreen.dart';
import 'model/ChatDTO.dart';

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<UserReceive> admins = [];
  String? userId;

  @override
  void initState() {
    super.initState();
    fetchAdmins();
    getId();
  }

  void getId() async {
    final storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt');
    String id = getUserIdFromToken(token);
    setState(() {
      userId = id;
    });
  }

  Future<void> fetchAdmins() async {
    try {
      List<UserReceive> fetchAdmins = await fetchAllAdmins();
      if (mounted) {
        setState(() {
          admins = fetchAdmins;
        });
      }
    }catch(e) {
      print('Failed to load admins: $e');
    }
  }

  Future<int> getUnreadMessageCount(String adminId) async {
    try {
      int unreadCount = await getUnreadMessageCountForAdmin(userId ?? '', adminId);
      return unreadCount;
    } catch (e) {
      print('Failed to get unread message count: $e');
      return 0;
    }
  }

  Future<void> readAllMessages(String adminId) async {
    ChatDTO chat = ChatDTO(
        user1: userId ?? '',
        user2: adminId
    );
    try{
      await markMessagesRead(chat.toJson());
    }catch (e) {
      print('Failed read messages: $e');
      return;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Message Experts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: const Text(
              'Ask our experts anything',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: admins.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(admins[index].email),
                    subtitle: Text(admins[index].name),
                    trailing: FutureBuilder<int>(
                      future: getUnreadMessageCount(admins[index].id),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error, color: Colors.red);
                        } else {
                          int unreadCount = snapshot.data ?? 0;
                          return CircleAvatar(
                            backgroundColor: unreadCount > 0 ? Colors.red : Colors.transparent,
                            child: Text(unreadCount.toString(), style: TextStyle(color: Colors.white)),
                          );
                        }
                      },
                    ),
                    onTap: () {
                      readAllMessages(admins[index].id);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen(adminId: admins[index].id, userId: userId)),
                      ).then((_) {
                        setState(() {
                        });
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}