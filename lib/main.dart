import 'package:capstone_project/pages/login_page.dart';
import 'package:capstone_project/pages/lost_item.dart';
//import 'package:capstone_project/pages/register_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LostItemPage(),
    );
  }
}
