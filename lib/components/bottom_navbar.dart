import 'package:capstone_project/pages/home_page.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {

  final int selectedIndex;
  final Function(int) onItemSelected;
  const BottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      color: const Color.fromRGBO(43, 52, 153, 1),
      animationDuration: Duration(milliseconds: 300),
      onTap: onItemSelected,
      index: selectedIndex,
      items: [
        Icon(
          Icons.visibility_off,
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
          Icons.visibility,
          color: Colors.white,
        ),
      ],
    );
  }
}