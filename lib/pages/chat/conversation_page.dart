import 'dart:io';

import 'package:capstone_project/models/message_model.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/pages/chat/preview_page.dart';
import 'package:capstone_project/pages/finish_page.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:capstone_project/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/themes/theme.dart';
import 'package:capstone_project/components/chat_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ConversationPage extends StatefulWidget {
  final String chatId;
  final String memberId;
  final String memberName;
  final String memberImage;
  const ConversationPage({
    Key? key,
    required this.chatId,
    required this.memberId,
    required this.memberName,
    required this.memberImage,
  }) : super(key: key);

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  bool _isFocused = false;
  List<Message> _messages = []; // Store fetched messages here

  SocketService _socketService = SocketService(); // Use SocketService instance

  RemoteService _remoteService =
      RemoteService(); // Create an instance of RemoteService

  _connectSocket() {
    _socketService.socket?.onConnect((data) => print('Connected'));
    _socketService.socket
        ?.onConnectError((data) => print('Connect Error: $data'));
    _socketService.socket?.onDisconnect((data) => print('Disconnected'));
  }

  // Method to initialize the socket
  Future<void> initializeSocket() async {
    try {
      await _socketService
          .initializeSocket(); // Initialize socket using SocketService
      print('Socket connected');
      final uid = Provider.of<UserProvider>(context, listen: false).uid;
      _socketService.socket?.emit("new-user-add", uid);
      _socketService.socket?.on("receive-message", (data) {
        print(data);
        if (data is Map<String, dynamic>) {
          String receiverId = data['receiverId'];
          if (receiverId != widget.memberId) {
            String? messageText = data['message'];
            String? imageUrl = data['imageUrl'];
            if (imageUrl != null) {
              // If imageUrl is present
              String senderId = data['senderId'];
              DateTime createdAt = DateTime.now();
              Message receivedMessage = Message(
                senderId: senderId,
                message: null,
                imageUrl: imageUrl,
                createdAt: createdAt,
              );
              setState(() {
                _messages.add(receivedMessage);
              });
            } else if (messageText != null) {
              // If messageText is present
              String senderId = data['senderId'];
              DateTime createdAt = DateTime.now();
              Message receivedMessage = Message(
                senderId: senderId,
                message: messageText,
                imageUrl: null,
                createdAt: createdAt,
              );
              setState(() {
                _messages.add(receivedMessage);
              });
            }
          }
        }
      });
    } catch (e) {
      print('Failed to connect to socket: $e');
    }
  }

  void _sendMessageToRemote(String message, String chatId, String token) async {
    try {
      String senderId =
          Provider.of<UserProvider>(context, listen: false).uid ?? '';
      await _remoteService.sendMessage(
          chatId: chatId, token: token, message: message);
      // Emit message to the socket server
      _socketService.socket?.emit("send-message", {
        'senderId': senderId,
        'receiverId': widget.memberId,
        'message': message
      });
      print('Message sent to socket: $message'); // Confirmation message
      // Add the sent message to the UI directly
      Message sentMessage = Message(
        senderId: senderId,
        message: message,
        createdAt: DateTime.now(),
      );
      setState(() {
        _messages.add(sentMessage);
      });
      // Clear the text field after sending the message
      _textEditingController.clear();
    } catch (e) {
      print('Error sending message: $e');
      // Handle error appropriately
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

// Method to fetch messages
  void _fetchMessages() async {
    try {
      List<Message> messages = await RemoteService().getMessages(widget.chatId);
      print(messages);
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      print('Error fetching messages: $e');
    }
  }

  // Method to navigate to ImagePreviewPage and handle the result
  Future<void> _navigateToImagePreviewPage(File imageFile) async {
    final sentMessage = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePreviewPage(
          imageFile: imageFile,
          chatId: widget.chatId,
          memberId: widget.memberId,
        ),
      ),
    );
    if (sentMessage != null) {
      setState(() {
        _messages.add(sentMessage);
      });
    }
  }

// Function to handle selecting an image from the device's gallery
  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _navigateToImagePreviewPage(File(pickedFile.path));
    } else {
      // User canceled the picker
    }
  }

  @override
  void initState() {
    super.initState();
    initializeSocket();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _textEditingController = TextEditingController();
    _fetchMessages();
  }

  // Widget to build chat bubbles from messages
  Widget _buildChatBubbles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _messages.map((message) {
        // Check if the message is null and imageUrl is present
        if (message.message == null && message.imageUrl != null) {
          bool isUserMessage = message.senderId != widget.memberId;
          return isUserMessage
              ? ChatBubbleUser(
                  imageUrl: message.imageUrl!,
                )
              : ChatBubble(
                  imageUrl: message.imageUrl!,
                );
        }
        // Check if the message is present and imageUrl is either present or not
        else if (message.message != null) {
          bool isUserMessage = message.senderId != widget.memberId;
          return isUserMessage
              ? ChatBubbleUser(
                  text: message.message!,
                )
              : ChatBubble(
                  text: message.message!,
                );
        } else {
          return Container(); // Return an empty container for other cases
        }
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Change body color to white
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Row(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(widget.memberImage),
                  radius: 16, // Adjust the size as needed
                ),
                SizedBox(width: 8), // Adjust the spacing between image and text
                Container(
                  // Wrap the Text widget with Container
                  constraints: BoxConstraints(
                      maxWidth: 90), // Adjust the maximum width as needed
                  child: Text(
                    widget.memberName,
                    style: TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis, // Handle long names
                  ),
                ),
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FinishPage()), // Replace FinishPage with the actual page you want to navigate to
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  'FINISH TRANSACTION',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: const [],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildChatBubbles(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            color: primaryColor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextField(
                        controller: _textEditingController,
                        focusNode: _focusNode,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16.0),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  if (!_isFocused) ...[
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        final chatId = widget.chatId;
                        final token =
                            Provider.of<UserProvider>(context, listen: false)
                                .token;
                        final message = _textEditingController.text;
                        ''; // Empty string for now, replace with actual imageUrl when sending an image
                        if (token != null) {
                          _sendMessageToRemote(message, chatId,
                              token); // Pass imageUrl to the function
                          _textEditingController
                              .clear(); // Clear the text field after sending the message
                        } else {
                          print('One of the parameters is null');
                          // Handle the case where one of the parameters is null
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Action to send image
                        _getImageFromGallery();
                      },
                    ),
                  ] else ...[
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        final chatId = widget.chatId;
                        final token =
                            Provider.of<UserProvider>(context, listen: false)
                                .token;
                        final message = _textEditingController.text;

                        ''; // Empty string for now, replace with actual imageUrl when sending an image
                        if (token != null) {
                          _sendMessageToRemote(message, chatId,
                              token); // Pass imageUrl to the function
                          _textEditingController
                              .clear(); // Clear the text field after sending the message
                        } else {
                          print('One of the parameters is null');
                          // Handle the case where one of the parameters is null
                        }
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
