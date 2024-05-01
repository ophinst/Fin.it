class Message {
  String? messageId;
  String? chatId;
  String senderId;
  String? message; // Updated to nullable
  DateTime createdAt;
  DateTime? updatedAt;
  String? imageUrl;

  Message({
    this.messageId,
    this.chatId,
    required this.senderId,
    this.message, // Updated to nullable
    required this.createdAt,
    this.updatedAt,
    this.imageUrl,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      messageId: json['messageId'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      message: json['message'],
      // Parse createdAt and updatedAt strings to DateTime objects
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      imageUrl: json['imageUrl'],
    );
  }
}
