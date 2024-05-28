import 'package:capstone_project/models/message_model.dart';
import 'package:capstone_project/services/socket_service.dart';
import 'package:capstone_project/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/components/chat_box.dart';
import 'package:capstone_project/components/search_bar.dart';
import 'package:provider/provider.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/services/remote_service.dart';

class ChatPage extends StatefulWidget {
  final SocketService socketService;

  const ChatPage({super.key, required this.socketService});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController searchController = TextEditingController();
  List<GlobalKey<ChatBoxState>> chatBoxKeys = []; // Store keys for each ChatBox
  List<ChatBox> chatBoxes = []; // List to store ChatBox widgets
  List<ChatBox> filteredChatBoxes =
      []; // List to store filtered ChatBox widgets

  final RemoteService remoteService = RemoteService();

  var isLoaded = false;
  bool isLoading = false; // Flag to track loading state
  bool isDisposed = false; // Flag to track if the widget is disposed

  String formatCreatedAt(String createdAt) {
    final createdAtDateTime = DateTime.parse(createdAt);
    final difference = DateTime.now().difference(createdAtDateTime);
    if (difference.inHours < 24) {
      return '${createdAtDateTime.hour.toString().padLeft(2, '0')}:${createdAtDateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${createdAtDateTime.day.toString().padLeft(2, '0')}-${createdAtDateTime.month.toString().padLeft(2, '0')}';
    }
  }

  Future<void> fetchChats() async {
    try {
      setState(() {
        isLoading = true;
      });

      final token = Provider.of<UserProvider>(context, listen: false).token;
      final uid = Provider.of<UserProvider>(context, listen: false).uid;

      if (token != null) {
        final dynamic response =
            await remoteService.getChats(token).catchError((e) {
          throw e;
        });

        final List<dynamic>? chatData = response['data'];

        if (chatData != null) {
          chatBoxes.clear();
          filteredChatBoxes.clear();
          chatBoxKeys.clear(); // Clear keys list

          final List<Future<void>> futures = []; // List to hold futures

          for (var chat in chatData) {
            futures.add(_processChat(chat, uid)); // Add futures to the list
          }

          await Future.wait(futures); // Wait for all futures to complete

          chatBoxes.sort((a, b) =>
              b.recentMessageCreatedAt.compareTo(a.recentMessageCreatedAt));
          if (!isDisposed) {
            setState(() {
              filteredChatBoxes = List.from(chatBoxes);
              isLoaded = true;
            });
          }
        }
      }
    } catch (e) {
      // Handle errors
    } finally {
      if (!isDisposed) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _processChat(Map<String, dynamic> chat, String? uid) async {
    final List<dynamic>? members = chat['members'];

    if (members != null && uid != null) {
      final filteredMembers =
          members.where((memberId) => memberId != uid).toList();
      String memberId = filteredMembers.first;
      String memberName = '';
      String memberImage = '';
      String recentMessage = 'Start Chatting Now!';
      String recentMessageCreatedAt = '2000-01-01T00:00:00.000Z';

      if (filteredMembers.isNotEmpty) {
        final user = await remoteService
            .getUserById(filteredMembers.first)
            .catchError((e) {
          throw e;
        });
        if (user != null) {
          memberName = user.name;
          memberImage = user.image ??
              'https://storage.googleapis.com/ember-finit/lostImage/fin-H8xduSgoh6/93419946.jpeg';
        }
      }

      final List<Message> messagesResponse =
          await remoteService.getMessages(chat['chatId']).catchError((e) {
        throw e;
      });
      if (messagesResponse.isNotEmpty) {
        messagesResponse.sort((a, b) => b.createdAt.compareTo(a.createdAt));

        final Message recentMessageObject = messagesResponse.first;
        if (recentMessageObject.message != null) {
          recentMessage = recentMessageObject.message!;
        } else if (recentMessageObject.imageUrl != null) {
          recentMessage = 'Image';
        }
        recentMessageCreatedAt = recentMessageObject.createdAt.toString();
      }

      final String itemId = chat['itemId'];
      late String itemName = 'Loading';
      late String itemDate = 'Loading';

      if (itemId.startsWith('fou')) {
        dynamic foundItem = await remoteService.getFoundByIdJson(itemId);
        if (foundItem['status'] == 200) {
          var data = foundItem['data'];
          itemName = data['itemName'] ?? 'Unknown Item';
          itemDate = data['foundDate'] ?? 'Unknown Date';
        } else if (foundItem['status'] == 404) {
          itemName = 'Item Not Found';
          itemDate = '00-00-00';
        }
      } else if (itemId.startsWith('los')) {
        dynamic lostItem = await remoteService.getLostByIdJson(itemId);
        if (lostItem['status'] == 200) {
          var data = lostItem['data'];
          itemName = data['itemName'] ?? 'Unknown Item';
          itemDate = data['lostDate'] ?? 'Unknown Date';
        } else if (lostItem['status'] == 404) {
          itemName = 'Item Not Found';
          itemDate = '00-00-00';
        }
      }

      var chatBoxKey = GlobalKey<ChatBoxState>();
      var chatBox = ChatBox(
        key: chatBoxKey,
        chatId: chat['chatId'],
        memberId: memberId,
        memberName: memberName,
        memberImage: memberImage,
        recentMessage: recentMessage,
        recentMessageCreatedAt: recentMessageCreatedAt,
        itemId: itemId,
        itemName: itemName,
        itemDate: itemDate,
        onBack: fetchChats,
      );

      if (!isDisposed) {
        setState(() {
          chatBoxes.add(chatBox);
          chatBoxKeys.add(chatBoxKey); // Add key to list
        });
      }
    }
  }

  void searchChats(String query) {
    if (!isDisposed) {
      setState(() {
        filteredChatBoxes = chatBoxes.where((chatBox) {
          return chatBox.memberName
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              chatBox.recentMessage.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void _handleReceiveMessage(dynamic data) async {
    if (!mounted) return;
    final Map<String, dynamic> messageData = data as Map<String, dynamic>;
    final String? receiverId = messageData['receiverId'];
    final String senderId = messageData['senderId'];
    final String chatId = messageData['chatId'];
    final String? message = messageData['message'];
    final String? imageUrl = messageData['imageUrl'];

    final uid = Provider.of<UserProvider>(context, listen: false).uid;
    if (receiverId == uid && senderId != uid) {
      if (!isDisposed) {
        setState(() {
          int chatBoxIndex = chatBoxKeys
              .indexWhere((key) => key.currentState?.widget.chatId == chatId);
          if (chatBoxIndex != -1) {
            var chatBox = chatBoxes.removeAt(chatBoxIndex);
            chatBoxes.insert(0, chatBox);
            chatBoxKeys.insert(0, chatBoxKeys.removeAt(chatBoxIndex));
            const messageText = 'Image';
            if (message != null) {
              chatBoxKeys[0].currentState?.updateRecentMessage(message);
            } else if (imageUrl != null) {
              chatBoxKeys[0].currentState?.updateRecentMessage(messageText);
            }
            chatBoxes.sort((a, b) =>
                b.recentMessageCreatedAt.compareTo(a.recentMessageCreatedAt));
            filteredChatBoxes = List.from(chatBoxes);
          }
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchChats();
    widget.socketService.socket?.on("receive-message", _handleReceiveMessage);
  }

  @override
  void dispose() {
    isDisposed = true;
    widget.socketService.socket?.off("receive-message", _handleReceiveMessage);
    searchController.dispose();
    super.dispose();
  }

  void refreshChats() {
    fetchChats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchChats,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                children: [
                  const Row(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                          top: 25,
                        ),
                        child: GestureDetector(
                          onTap: fetchChats,
                          child: const Text(
                            'Chat',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'JosefinSans',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 25,
                          top: 25,
                        ),
                        child: GestureDetector(
                          onTap: fetchChats,
                          child: Icon(
                            Icons.refresh,
                            color: primaryColor,
                          ),
                        ),
                      ),
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: SrcBar(
                            searchController: searchController,
                            onSearch: searchChats,
                            size: 157,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Show circular progress indicator if loading, else show chat boxes
                  Column(
                    children: [
                      isLoading
                          ? const CircularProgressIndicator()
                          : filteredChatBoxes.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No chats',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Column(
                                  children: [
                                    for (var chatBox in filteredChatBoxes)
                                      Column(
                                        children: [
                                          chatBox,
                                          const SizedBox(
                                            height: 10,
                                          ), // Add SizedBox between ChatBoxes
                                        ],
                                      ),
                                  ],
                                ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
