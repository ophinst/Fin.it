import 'package:capstone_project/pages/chat/conversation_page.dart';
import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  final String chatId;
  final String memberName;
  final String memberImage;
  final String recentMessage;
  final String recentMessageCreatedAt;
  const ChatBox({
    Key? key,
    required this.chatId,
    required this.memberName,
    required this.memberImage,
    required this.recentMessage,
    required this.recentMessageCreatedAt,
  }) : super(key: key);

  String formatCreatedAt(String createdAt) {
    // Parse the createdAt string into a DateTime object
    final createdAtDateTime = DateTime.parse(createdAt);

    // Calculate the difference between the createdAt time and the current device time
    final difference = DateTime.now().difference(createdAtDateTime);

    // Check if the difference is less than 24 hours
    if (difference.inHours < 24) {
      // Display only the time in hour and minutes
      return '${createdAtDateTime.hour.toString().padLeft(2, '0')}:${createdAtDateTime.minute.toString().padLeft(2, '0')}';
    } else {
      // Display just the date and month
      return '${createdAtDateTime.day.toString().padLeft(2, '0')}-${createdAtDateTime.month.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ConversationPage(
            chatId: chatId,
            memberName: memberName,
            // memberImage: memberImage,
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
                      formatCreatedAt(recentMessageCreatedAt),
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
