import 'package:fitnessapp/utils/jwt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fitnessapp/model/UserReceive.dart';
import 'package:fitnessapp/services/chatService.dart';
import 'ChatScreen.dart';
import 'model/AdminChatReceive.dart';
import 'model/ChatDTO.dart';

class AdminMessageScreen extends StatefulWidget {
  @override
  _AdminMessageScreenState createState() => _AdminMessageScreenState();
}

class _AdminMessageScreenState extends State<AdminMessageScreen> {
  List<AdminChatReceive> chatUsers = [];
  late String id;

  @override
  void initState() {
    super.initState();
    fetchUsersWithMessages();
  }

  Future<void> fetchUsersWithMessages() async {
    try {
      final storage = FlutterSecureStorage();
      String? token = await storage.read(key: 'jwt');
      String idAdmin = getUserIdFromToken(token);
      id = idAdmin;
      List<AdminChatReceive> fetchedUsers = await fetchNewAdminChats(id);
      if (mounted) {
        setState(() {
          chatUsers = fetchedUsers;
        });
      }
    } catch (e) {
      print('Failed to load users: $e');
    }
  }

  Future<void> readAllMessages(String userId) async {
    ChatDTO chat = ChatDTO(
        user1: id ?? '',
        user2: userId
    );
    try{
      await markMessagesRead(chat.toJson());
    }catch (e) {
      print('Failed read messages: $e');
      return;
    }
  }

  Future<int> getUnreadMessageCount(String userId) async {
    try {
      int unreadCount = await getUnreadMessageCountForAdmin(id ?? '', userId);
      return unreadCount;
    } catch (e) {
      print('Failed to get unread message count: $e');
      return 0;
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
              'Your chats',
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
              itemCount: chatUsers.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(chatUsers[index].name),
                    trailing: FutureBuilder<int>(
                      future: getUnreadMessageCount(chatUsers[index].sent_by),
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
                      readAllMessages(chatUsers[index].sent_by);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatScreen(adminId: chatUsers[index].sent_by, userId: id)),
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

      // body: ListView.builder(
      //   itemCount: chatUsers.length,
      //   itemBuilder: (context, index) {
      //     return ListTile(
      //       title: Text(chatUsers[index].name),
      //       subtitle: Text('You have unread messages'),
      //       onTap: () {
      //         Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => ChatScreen(adminId: chatUsers[index].sent_by, userId: id),
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
