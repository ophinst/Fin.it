// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:capstone_project/components/chat_box.dart';
import 'package:capstone_project/components/search_bar.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'LOST & FOUND',
                      style: TextStyle(
                        fontFamily: 'josefinSans',
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        left: 25,
                        top: 25,
                      ),
                      child: Text(
                        'Chat',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'JosefinSans',
                        ),
                      ),
                    ),
                    // SizedBox(
                    //   width: 12,
                    // ),
                    // SrcBar(),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
                  height: 2,
                  color: Colors.black,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 25,
                        ),
                          child: AnotherSearchBar(
                            searchController: searchController,
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                ChatBox(),
                SizedBox(height: 10),
                ChatBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
