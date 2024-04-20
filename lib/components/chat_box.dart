import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:capstone_project/pages/chat/conversation_page.dart';

typedef void ChatRefreshCallback();

class ChatBox extends StatelessWidget {
  final ChatRefreshCallback? onChatRefresh;
  final String chatId;
  final String memberId;
  final String memberName;
  final String memberImage;
  final String recentMessage;
  final String recentMessageCreatedAt;
  final VoidCallback? fetchChats;
  final IO.Socket? socket; // Accept socket object
  const ChatBox({
    Key? key,
    this.onChatRefresh,
    required this.chatId,
    required this.memberId,
    required this.memberName,
    required this.memberImage,
    required this.recentMessage,
    required this.recentMessageCreatedAt,
    this.fetchChats,
    this.socket, // Include socket object in the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse recentMessageCreatedAt to DateTime
    DateTime createdAtDateTime = DateTime.parse(recentMessageCreatedAt);

    // Format the difference between createdAtDateTime and current time using timeago
    String formattedTimeAgo =
        timeAgo.format(createdAtDateTime, locale: 'en_short');
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ConversationPage(
            chatId: chatId,
            memberId: memberId,
            memberName: memberName,
            memberImage: memberImage,
            // socket: socket, // Pass the socket object to ConversationPage
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
                        memberImage,
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
                        memberName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            recentMessage,
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
