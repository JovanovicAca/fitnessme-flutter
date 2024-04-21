import 'dart:convert';

import 'package:fitnessapp/services/chatService.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'model/ChatDTO.dart';
import 'model/Message.dart';

class ChatScreen extends StatefulWidget {
  final String adminId;
  final String? userId;

  const ChatScreen({Key? key, required this.adminId, required this.userId}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool _chatExists = false;
  String? _currentChatId;
  List<Message> messages = [];
  TextEditingController _messageController = TextEditingController();
  late final WebSocketChannel _channel;
  String currentText = '';
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _channel.sink.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.0.14:3003/ws'),
    );
    _checkChatExistence();

    _channel.stream.listen((message) {
      var receivedMessage = Message.fromJson(jsonDecode(message));
      if (receivedMessage.text != currentText){
        setState(() {
          messages.last.status = 'seen';
          messages.add(receivedMessage);
        });
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 100), _scrollToBottom);
    });
  }


  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  void _sendMessage() {
    final message = {
      "text": _messageController.text,
      "sent_by": widget.userId,
      "sent_to": widget.adminId,
      "replied_on": "",
      "chat_id": _currentChatId,
    };
    _channel.sink.add(jsonEncode(message));
    currentText = _messageController.text;

    final sentMessage = Message(
      id: '',
      text: _messageController.text,
      sent_by: widget.userId ?? '',
      sent_to: widget.adminId,
      status: 'delivered',
      chat_id: '',
      replied_on: '',
    );
    _messageController.clear();

    setState(() {
      messages.add(sentMessage);
    });
    _scrollToBottom();
  }

  Future<void> _checkChatExistence() async {
    String? chatId = await getChat(widget.userId ?? '', widget.adminId);
    if (chatId != null && chatId.isNotEmpty) {
      setState(() {
        _chatExists = true;
        _currentChatId = chatId;
      });
      if (_chatExists) {
        loadMessages(chatId);
      }
    } else{
      await _createChat();
      final String? newChatId = await getChat(widget.userId ?? '', widget.adminId);
      setState(() {
        if (newChatId != null && newChatId.isNotEmpty) {
          _chatExists = true;
          _currentChatId = newChatId;
        }
        else{
          _chatExists = false;
        }
      });
    }
  }

  void loadMessages(chatId) async {
    List<Message> chatMessages = await getMessagesFromChat(chatId);
    if (mounted){
      setState(() {
        messages = chatMessages;
      });
    }
  }

  Future<void> _createChat() async {
    ChatDTO chat = ChatDTO(
      user1: widget.userId ?? '',
      user2: widget.adminId
    );
    var response = await saveChat(chat.toJson());
    if (mounted){
      if (response.statusCode == 201){
        print('saved chat');
      }
      else {
        print(response.body);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with Admin'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _chatExists
          ? Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                bool isSentByUser = messages[index].sent_by == widget.userId;
                return Row(
                  mainAxisAlignment: isSentByUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                  children: [
                    Container(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: isSentByUser ? Colors.blue : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        messages[index].text,
                        style: TextStyle(
                          color: isSentByUser ? Colors.white : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (isSentByUser)
                      Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.done_all,
                              size: 14,
                              color: messages[index].status == 'delivered' ? Colors.grey : Colors.transparent,
                            ),
                            Icon(
                              Icons.done_all,
                              size: 14,
                              color: messages[index].status == 'seen' ? Colors.blue : Colors.transparent,
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
