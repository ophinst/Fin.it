import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:capstone_project/pages/chat/conversation_page.dart';

class ChatBox extends StatefulWidget {
  final String chatId;
  final String memberId;
  final String memberName;
  final String memberImage;
  String recentMessage; // Change to non-final to allow modification
  final String recentMessageCreatedAt;
  final String itemId; // New parameter for itemId
  final String itemName; // New parameter for itemId
  final String itemDate; // New parameter for itemId
  final VoidCallback? fetchChats;
  final Function(String) updateRecentMessage; // Callback function

  ChatBox({
    super.key,
    required this.chatId,
    required this.memberId,
    required this.memberName,
    required this.memberImage,
    required this.recentMessage,
    required this.itemId,
    required this.itemName,
    required this.itemDate,
    required this.recentMessageCreatedAt,
    this.fetchChats,
    required this.updateRecentMessage, // Pass the callback function
  });

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {

  void updateRecentMessage(String newMessage) {
  setState(() {
    widget.recentMessage = newMessage;
  });
}

  @override
  Widget build(BuildContext context) {
    // Parse recentMessageCreatedAt to DateTime
    DateTime createdAtDateTime = DateTime.parse(widget.recentMessageCreatedAt);

    // Format the difference between createdAtDateTime and current time using timeago
    String formattedTimeAgo =
        timeAgo.format(createdAtDateTime, locale: 'en_short');
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ConversationPage(
            chatId: widget.chatId,
            memberId: widget.memberId,
            memberName: widget.memberName,
            memberImage: widget.memberImage,
            itemId: widget.itemId,
            itemName: widget.itemName,
            itemDate: widget.itemDate,
          ),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ClipOval(
                      child: Image.network(
                        widget.memberImage,
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.memberName} (${widget.itemName})',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            widget.recentMessage,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formattedTimeAgo,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: 1,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }
}
