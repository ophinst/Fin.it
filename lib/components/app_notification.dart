import 'package:flutter/material.dart';

class InAppNotification extends StatelessWidget {
  final String message;
  final String senderName;

  const InAppNotification({Key? key, required this.message, required this.senderName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      // color: Colors.blue, // Customize color as needed
      child: Row(
        children: [
          const Icon(Icons.notifications, color: Colors.white),
          const SizedBox(width: 10),
          Text(
            '$senderName: $message',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

