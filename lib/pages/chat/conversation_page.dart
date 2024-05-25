import 'dart:io';

import 'package:capstone_project/models/lost_item_model.dart';
import 'package:capstone_project/models/message_model.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/pages/chat/preview_page.dart';
import 'package:capstone_project/pages/finish_transaction.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:capstone_project/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/themes/theme.dart';
import 'package:capstone_project/components/chat_bubble.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class ConversationPage extends StatefulWidget {
  final String chatId;
  final String memberId;
  final String memberName;
  final String memberImage;
  final String itemId;
  final String itemName;
  final String itemDate;
  final VoidCallback? onBack; // Make the onBack parameter optional

  const ConversationPage({
    super.key,
    required this.chatId,
    required this.memberId,
    required this.memberName,
    required this.memberImage,
    required this.itemId,
    required this.itemName,
    required this.itemDate,
    this.onBack, // Accept the optional callback as a parameter
  });

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late FocusNode _focusNode;
  late TextEditingController _textEditingController;
  bool _isFocused = false;
  List<Message> _messages = []; // Store fetched messages here
  late String itemStatus = '';
  bool foundUserStatus = false; // Variable to store foundUserStatus
  bool lostUserStatus = false; // Variable to store lostUserStatus
  bool _isSocketInitialized = false; // Flag to track socket initialization
  Timer? _timer; // Declare a Timer variable

  final SocketService _socketService = SocketService(); // Use SocketService instance

  final RemoteService _remoteService =
      RemoteService(); // Create an instance of RemoteService


  // Method to initialize the socket
  Future<void> initializeSocket() async {
    try {
      await _socketService.initializeSocket(); // Initialize socket using SocketService
    _socketService.socket?.onDisconnect((_) {
      // Reset the flag when the socket disconnects
      _isSocketInitialized = false;
      initializeSocket(); // Reconnect
    });

    // Check if the socket is already initialized before emitting "new-user-add"
    if (!_isSocketInitialized) {
      final uid = Provider.of<UserProvider>(context, listen: false).uid;
      _socketService.socket?.emit("new-user-add", uid);
    }
      _socketService.socket?.on("receive-message", (data) {
        if (data is Map<String, dynamic>) {
          String receiverId = data['receiverId'];
          if (receiverId != widget.memberId) {
            String? messageText = data['message'];
            String? imageUrl = data['imageUrl'];
            String chatId = widget.chatId;
            if (imageUrl != null) {
              // If imageUrl is present
              String senderId = data['senderId'];
              DateTime createdAt = DateTime.now();
              Message receivedMessage = Message(
                senderId: senderId,
                chatId: chatId,
                message: null,
                imageUrl: imageUrl,
                createdAt: createdAt,
              );
              // Check if the widget is mounted before calling setState
              if (mounted) {
                setState(() {
                  _messages.add(receivedMessage);
                });
              }
            } else 
            if (messageText != null) {
              // If messageText is present
              String senderId = data['senderId'];
              DateTime createdAt = DateTime.now();
              Message receivedMessage = Message(
                senderId: senderId,
                chatId: chatId,
                message: messageText,
                imageUrl: null,
                createdAt: createdAt,
              );
              // Check if the widget is mounted before calling setState
              if (mounted) {
                setState(() {
                  _messages.add(receivedMessage);
                });
              }
            }
          }
        }
      });

      _isSocketInitialized = true;
    } catch (e) {
      rethrow;
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
        'chatId': widget.chatId,
        'message': message
      });
      // Confirmation message
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
      // Handle error appropriately
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
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
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> getItemDetails(String itemId) async {
  try {
    if (itemId.startsWith('fou')) {
      dynamic foundItem = await _remoteService.getFoundByIdJson(itemId);
      if (foundItem['status'] == 200) {
      var data = foundItem['data'];
      if (foundItem != null) {
        foundUserStatus = data['foundUserStatus']; // Update class-level variable
        lostUserStatus = data['lostUserStatus']; // Update class-level variable
        if (!foundUserStatus && !lostUserStatus) {
          itemStatus = 'Available';
        } else if (!lostUserStatus && foundUserStatus) {
          itemStatus = 'Awaiting lost user approval';
        } else if (!foundUserStatus && lostUserStatus) {
          itemStatus = 'Awaiting founder approval';
        } else {
          itemStatus = 'Item Claimed';
        }
      } 
    } else if (foundItem['status'] == 404) {
        itemStatus = '---';
      }
    } else if (itemId.startsWith('los')) {
      // Datum? lostItem = await _remoteService.getLostItemById(itemId);
      dynamic lostItem = await _remoteService.getLostByIdJson(itemId);
      if (lostItem['status'] == 200) {
        var data = lostItem['data'];
        if (lostItem != null) {
          foundUserStatus = data['foundUserStatus']; // Update class-level variable
          lostUserStatus = data['lostUserStatus']; // Update class-level variable
          if (!foundUserStatus && !lostUserStatus) {
            itemStatus = 'Available';
          } else if (!lostUserStatus && foundUserStatus) {
            itemStatus = 'Awaiting lost user approval';
          } else if (!foundUserStatus && lostUserStatus) {
            itemStatus = 'Awaiting founder approval';
          } else {
            itemStatus = 'Item Claimed';
          }
        } 
      } else if (lostItem['status'] == 404) {
        itemStatus = '---';
      }
    }
    // Update the UI after fetching item details
    setState(() {});
  } catch (e) {
    rethrow;
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
    getItemDetails(widget.itemId);
    itemStatus = 'Loading...';
    // Start the timer to call getItemDetails every 10 seconds
  _timer = Timer.periodic(const Duration(seconds: 10), (Timer t) {
    getItemDetails(widget.itemId);
  });
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
                const SizedBox(width: 8), // Adjust the spacing between image and text
                Container(
                  // Wrap the Text widget with Container
                  constraints: const BoxConstraints(
                      maxWidth: 90), // Adjust the maximum width as needed
                  child: Text(
                    widget.memberName,
                    style: const TextStyle(color: Colors.white),
                    overflow: TextOverflow.ellipsis, // Handle long names
                  ),
                ),
              ],
            ),
            const Spacer(),
            if (!(foundUserStatus && lostUserStatus) && itemStatus != '---') // Check if neither found nor lost
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FinishTransaction(
                      itemId: widget.itemId,
                      itemName: widget.itemName,
                      itemDate: widget.itemDate,
                      foundUserStatus: foundUserStatus,
                      lostUserStatus: lostUserStatus,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: const Text(
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
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
            if (widget.onBack != null) {
              widget.onBack!(); // Trigger the callback to refresh ChatPage if provided
            }
          },
        ),
        actions: const [],
      ),
      body: Column(
        children: [
          Container(
            color: primaryColor,
            padding: const EdgeInsets.all(12),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaction of: ${widget.itemName}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white),
                ),
                Text(
                  itemStatus,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.yellow),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              reverse: true,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        decoration: const BoxDecoration(
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
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: TextField(
                        controller: _textEditingController,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
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
                      icon: const Icon(
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
                          // Handle the case where one of the parameters is null
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(
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
                      icon: const Icon(
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