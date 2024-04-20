class Message {
   String? messageId;
   String? chatId;
   String senderId;
   String message;
   DateTime createdAt;
   DateTime? updatedAt;

  Message({
    this.messageId,
    this.chatId,
    required this.senderId,
    required this.message,
    required this.createdAt,
    this.updatedAt,
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
class SendMessageRequestModel {
   String message;

  SendMessageRequestModel({required this.message});

  Map<String, dynamic> toJson() {
    return {
      'message': message,
    };
  }
}
