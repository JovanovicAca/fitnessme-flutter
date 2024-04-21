class ChatDTO {
  String user1;
  String user2;

  ChatDTO({
    required this.user1,
    required this.user2,
  });

  Map<String, dynamic> toJson() => {
    'user_1': user1,
    'user_2': user2
  };
}