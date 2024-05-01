class Chat {
  final String chatId;
  final List<String> members;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String itemId;

  Chat({
    required this.chatId,
    required this.members,
    required this.createdAt,
    required this.updatedAt,
    required this.itemId,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      chatId: json['chatId'],
      members: List<String>.from(json['members']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      itemId: json['itemId'],
    );
  }
}