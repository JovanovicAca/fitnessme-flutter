class Message {
  String id;
  String sent_by;
  String sent_to;
  String text;
  String status;
  String replied_on;
  String chat_id;

  Message({
    required this.id,
    required this.sent_by,
    required this.sent_to,
    required this.text,
    required this.status,
    required this.replied_on,
    required this.chat_id,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      sent_by: json['sent_by'],
      sent_to: json['sent_to'],
      text: json['text'],
      status: json['status'],
      replied_on: json['replied_on'],
      chat_id: json['chat_id'],
    );
  }
}