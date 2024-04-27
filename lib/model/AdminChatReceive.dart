class AdminChatReceive {
  String name;
  String sent_by;

  AdminChatReceive({
    required this.name,
    required this.sent_by,
  });

  factory AdminChatReceive.fromJson(Map<String, dynamic> json) {
    return AdminChatReceive(
      name: json['name'],
      sent_by: json['sent_by'],
    );
  }
}