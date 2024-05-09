import 'package:capstone_project/components/app_notification.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/pages/chat/chat_page.dart';
import 'package:capstone_project/pages/found_item_list.dart';
import 'package:capstone_project/pages/home_page.dart';
import 'package:capstone_project/pages/lost_item_list.dart';
import 'package:capstone_project/pages/recent_activity.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:capstone_project/services/socket_service.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 2;
    String? lostId;
  final RemoteService _remoteService = RemoteService();
  final SocketService _socketService = SocketService(); // Use SocketService instance

  void initializeSocket() {
  try {
    _socketService.initializeSocket().then((_) {
      final uid = Provider.of<UserProvider>(context, listen: false).uid;
      _socketService.socket?.emit("new-user-add", uid);
      _socketService.socket?.on("receive-message", (data) async {
        final Map<String, dynamic> messageData = data as Map<String, dynamic>;
        final String? receiverId = messageData['receiverId'];
        final String senderId = messageData['senderId'];
        final String? message = messageData['message'];
        final String? imageUrl = messageData ['imageUrl'];

        if (receiverId == uid && senderId != uid && message != null) {
          final user = await _remoteService.getUserById(senderId);
          final senderName = user?.name ?? 'Unknown';
          setState(() {
            _showInAppNotification(message, senderName);
          });
        } else if (receiverId == uid && senderId != uid && imageUrl != null){
          final user = await _remoteService.getUserById(senderId);
          final senderName = user?.name ?? 'Unknown';
          final messageText = "Image";
          setState(() {
            _showInAppNotification(messageText, senderName);
          });
        }
      });
    });
  } catch (e) {}
}

void _showInAppNotification(String message, String senderName) async {
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: InAppNotification(message: message, senderName: senderName),
        duration: Duration(seconds: 3), // Adjust duration as needed
      ),
    );
  }
}

// @override
// void dispose() {
//   _socketService.dispose();
//   super.dispose();
// }

@override
  void initState() {
    super.initState();
    initializeSocket();
  }


  final screens = [
    FoundItemList(),
    ActivityList(),
    HomePage(),
    ChatPage(),
    LostItemList(),
  ];

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(
        Icons.visibility,
        color: Colors.white,
      ),
      Icon(
        Icons.event_note,
        color: Colors.white,
      ),
      Icon(
        Icons.home,
        color: Colors.white,
      ),
      Icon(
        Icons.chat,
        color: Colors.white,
      ),
      Icon(
        Icons.visibility_off,
        color: Colors.white,
      ),
    ];

    return Scaffold(
      // extendBody: true,
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        key: navigationKey,
        backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
        color: const Color.fromRGBO(43, 52, 153, 1),
        animationDuration: const Duration(milliseconds: 300),
        index: index,
        items: items,
        onTap: (index) {
          setState(() {
            this.index = index;
            // lostId = null;
          });
        },
      ),
    );
  }
}
