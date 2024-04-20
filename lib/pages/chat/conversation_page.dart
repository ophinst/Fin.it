import 'package:capstone_project/models/message_model.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/themes/theme.dart';
import 'package:capstone_project/components/chat_bubble.dart';
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

  final IO.Socket _socket = IO.io('https://finit-api-ahawuso3sq-et.a.run.app', IO.OptionBuilder().setTransports(['websocket']).build());

  // late IO.Socket _socket;

  RemoteService _remoteService =
      RemoteService(); // Create an instance of RemoteService


  _connectSocket() {
    _socket.onConnect((data) => print('Connected'));
    _socket.onConnectError((data) => print('Connect Error: $data'));
    _socket.onDisconnect((data) => print('Disconnected'));
  }
  // Method to initialize the socket
//   Future<void> initializeSocket() async {
//   try {
//     // Initialize socket.io connection
//     // Connect to the socket
//     await _socket.connect();
//     print('Socket connected');
//     // Emit 'new-user-add' event with user ID
//     final uid = Provider.of<UserProvider>(context, listen: false).uid;
//     _socket.emit("new-user-add", uid);
//     // Listen for incoming messages
//     _socket.on("receive-message", (data) {
//       print(data);
//       // Fetch messages every time a new message is received
//       _fetchMessages();
//     });
//   } catch (e) {
//     print('Failed to connect to socket: $e');
//   }
// }
// Method to initialize the socket
Future<void> initializeSocket() async {
  try {
    // Initialize socket.io connection
    await _socket.connect();
    print('Socket connected');
    // Emit 'new-user-add' event with user ID
    final uid = Provider.of<UserProvider>(context, listen: false).uid;
    _socket.emit("new-user-add", uid);
    // Listen for incoming messages
    _socket.on("receive-message", (data) {
      print(data);
      // Parse the received data
      if (data is Map<String, dynamic> &&
          data.containsKey('receiverId') &&
          data.containsKey('message')) {
        // Extract receiverId and message
        String receiverId = data['receiverId'];
        String messageText = data['message'];
        // Check if the message is intended for this user
        if (receiverId != widget.memberId) {
          // Create a new Message object
          Message receivedMessage = Message(
            senderId: widget.memberId, // Assuming receiverId is senderId
            message: messageText,
            createdAt: DateTime.now(), // Add current time as createdAt
          );
          // Add the received message to the list of messages
          setState(() {
            _messages.add(receivedMessage);
          });
        }
      }
    });
  } catch (e) {
    print('Failed to connect to socket: $e');
  }
}


void _sendMessageToRemote(String message, String chatId, String token) async {
  try {
    await _remoteService.sendMessage(chatId, token, message);
    // Emit message to the socket server
    _socket.emit("send-message", {'receiverId': widget.memberId, 'message': message});
    print('Message sent to socket: $message'); // Confirmation message
    // Add the sent message to the UI directly
    Message sentMessage = Message(
      senderId: Provider.of<UserProvider>(context, listen: false).uid ?? '',
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
  _socket.disconnect(); // Disconnect the socket
  _socket.dispose(); // Dispose the socket
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
    // print(messages);
    setState(() {
      _messages = messages;
    });
  } catch (e) {
    print('Error fetching messages: $e');
  }
}


  @override
  void initState() {
    super.initState();
    // Initialize the socket
    initializeSocket();
    // _connectSocket();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _textEditingController = TextEditingController();
    // Call method to fetch messages
    _fetchMessages();
    // _listenForMessages();
  }
  // Widget to build chat bubbles from messages
  Widget _buildChatBubbles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _messages.map((message) {
        // Check if the senderId is equal to the memberId
        bool isUserMessage = message.senderId != widget.memberId;
        return isUserMessage
            ? ChatBubbleUser(
                text: message.message,
              ) // If senderId is different, use ChatBubble
            : ChatBubble(
                text: message.message,
              ); // If senderId is same, use ChatBubbleUser
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
            Container(
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
          ],
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: const [],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              reverse: true, // Reverse scrolling to start from the bottom
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
                        controller:
                            _textEditingController, // Attach the TextEditingController here
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
                        Icons.near_me,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Action to send GPS location
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Action to send image
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
                        if (token != null) {
                          _sendMessageToRemote(message, chatId, token);
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
