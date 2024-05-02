import 'package:capstone_project/pages/chat/chat_page.dart';
import 'package:capstone_project/pages/form_lost.dart';
import 'package:capstone_project/pages/found_item_list.dart';
import 'package:capstone_project/pages/home_page.dart';
import 'package:capstone_project/pages/lost_item_list.dart';
import 'package:capstone_project/pages/recent_activity.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 2;

  String? lostId;

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
            lostId = null;
          });
        },
      ),
    );
  }
}
