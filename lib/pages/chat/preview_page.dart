import 'dart:io';

import 'package:flutter/material.dart';
import 'package:capstone_project/models/message_model.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ImagePreviewPage extends StatefulWidget {
  final File imageFile;
  final String chatId;
  final String memberId;

  const ImagePreviewPage({
    Key? key,
    required this.imageFile,
    required this.chatId,
    required this.memberId,
  }) : super(key: key);

  @override
  _ImagePreviewPageState createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  late IO.Socket _socket;
  final RemoteService _remoteService = RemoteService();

  @override
  void initState() {
    super.initState();
    // Initialize the socket
    _socket = IO.io('https://finit-api-ahawuso3sq-et.a.run.app',
        IO.OptionBuilder().setTransports(['websocket']).build());
    _connectSocket();
  }

  void _connectSocket() {
    _socket.onConnect((data) => print('Connected'));
    _socket.onConnectError((data) => print('Connect Error: $data'));
    _socket.onDisconnect((data) => print('Disconnected'));
  }

  void _sendMessageToRemote(
    String? message, File imageFile, String token, String chatId) async {
  try {
    String senderId =
        Provider.of<UserProvider>(context, listen: false).uid ?? '';
    var response = await _remoteService.sendMessage(
        chatId: chatId, token: token, message: message, imageFile: imageFile);

    String imageUrl = response.imageUrl ?? ''; // Extract imageUrl from response

    _socket.emit("send-message", {
      'senderId': senderId,
      'receiverId': widget.memberId,
      'imageUrl': imageUrl,
      'message': message,
    });
    if (message == null) {
    print('Message sent to socket: Image');
    }
    // Return the sent message along with the image to the previous screen
    Message sentMessage = Message(
      senderId: senderId,
      message: message, // Pass null as the message
      imageUrl: imageUrl, // Pass the imageUrl
      createdAt: DateTime.now(),
    );
    Navigator.pop(context, sentMessage); // Return the sent message
  } catch (e) {
    print('Error sending message: $e');
    // Handle error appropriately
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Preview'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.file(
                widget.imageFile,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                final token =
                    Provider.of<UserProvider>(context, listen: false).token ??
                        '';
                final chatId = widget.chatId;
                final message = null;
                _sendMessageToRemote(message, widget.imageFile, token,
                    chatId); // Pass imageFile instead of imagePath
              },
              child: Text('Send Image'),
            ),
          ),
        ],
      ),
    );
  }
}
