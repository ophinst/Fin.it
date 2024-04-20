import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  // final CrossAxisAlignment alignment;

  const ChatBubble({
    Key? key,
    required this.text,
    // this.alignment = CrossAxisAlignment.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
          decoration: BoxDecoration(
            color: Color.fromRGBO(66, 125, 157, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

class ChatBubbleUser extends StatelessWidget {
  final String text;
  // final CrossAxisAlignment alignment;

  const ChatBubbleUser({
    Key? key,
    required this.text,
    // this.alignment = CrossAxisAlignment.end,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
          decoration: BoxDecoration(
            color: Color.fromRGBO(131, 162, 255, 1),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10), 
              bottomLeft: Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
            ),
          ),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}

