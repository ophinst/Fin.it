class Message {
  final String messageId;
  final String chatId;
  final String senderId;
  final String message;
  final DateTime createdAt;
  final DateTime updatedAt;

  Message({
    required this.messageId,
    required this.chatId,
    required this.senderId,
    required this.message,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      message: json['message'],
      // Parse createdAt and updatedAt strings to DateTime objects
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
