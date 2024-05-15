import 'package:capstone_project/components/app_notification.dart';
import 'package:capstone_project/models/lost_item_model.dart';
import 'package:capstone_project/models/message_model.dart';
import 'package:capstone_project/services/socket_service.dart';
import 'package:capstone_project/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/components/chat_box.dart';
import 'package:capstone_project/components/search_bar.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController searchController = TextEditingController();
  List<ChatBox> chatBoxes = []; // List to store ChatBox widgets
  List<ChatBox> filteredChatBoxes = []; // List to store filtered ChatBox widgets

  final SocketService _socketService = SocketService(); // Use SocketService instance
  IO.Socket? socket;
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
        final dynamic response = await remoteService.getChats(token).catchError((e) {
          throw e;
        });

        final List<dynamic>? chatData = response['data'];

        if (chatData != null) {
          chatBoxes.clear();
          filteredChatBoxes.clear();

          for (var chat in chatData) {
            final List<dynamic>? members = chat['members'];

            if (members != null && uid != null) {
              final filteredMembers = members.where((memberId) => memberId != uid).toList();
              String memberId = filteredMembers.first;
              String memberName = '';
              String memberImage = '';
              String recentMessage = 'Start Chatting Now!';
              String recentMessageCreatedAt = '2000-01-01T00:00:00.000Z';

              if (filteredMembers.isNotEmpty) {
                final user = await remoteService.getUserById(filteredMembers.first).catchError((e) {
                  throw e;
                });
                if (user != null) {
                  memberName = user.name;
                  memberImage = user.image ?? 'https://storage.googleapis.com/ember-finit/lostImage/fin-H8xduSgoh6/93419946.jpeg';
                }
              }

              final List<Message> messagesResponse = await remoteService.getMessages(chat['chatId']).catchError((e) {
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
                itemName = foundItem['itemName'] ?? '';
                itemDate = foundItem['foundDate'] ?? '';
              } else if (itemId.startsWith('los')) {
                Datum? lostItem = await remoteService.getLostItemById(itemId);
                if (lostItem != null) {
                  itemName = lostItem.itemName;
                  itemDate = lostItem.lostDate;
                }
              }

              int existingChatIndex = chatBoxes.indexWhere((box) => box.chatId == chat['chatId']);
              if (existingChatIndex != -1) {
                if (!isDisposed) {
                  setState(() {
                    chatBoxes[existingChatIndex].memberName = memberName;
                    chatBoxes[existingChatIndex].memberImage = memberImage;
                    chatBoxes[existingChatIndex].recentMessage = recentMessage;
                    chatBoxes[existingChatIndex].recentMessageCreatedAt = recentMessageCreatedAt;
                    chatBoxes[existingChatIndex].itemName = itemName;
                    chatBoxes[existingChatIndex].itemDate = itemDate;
                  });
                }
              } else {
                var chatBox = ChatBox(
                  chatId: chat['chatId'],
                  memberId: memberId,
                  memberName: memberName,
                  memberImage: memberImage,
                  recentMessage: recentMessage,
                  recentMessageCreatedAt: recentMessageCreatedAt,
                  itemId: itemId,
                  itemName: itemName,
                  itemDate: itemDate,
                );
                if (!isDisposed) {
                  setState(() {
                    chatBoxes.add(chatBox);
                  });
                }
              }
            }
          }

          chatBoxes.sort((a, b) => b.recentMessageCreatedAt.compareTo(a.recentMessageCreatedAt));
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

  Future<void> fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      await fetchChats();
    } finally {
      if (!isDisposed) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void searchChats(String query) {
    if (!isDisposed) {
      setState(() {
        filteredChatBoxes = chatBoxes.where((chatBox) {
          return chatBox.memberName.toLowerCase().contains(query.toLowerCase()) ||
              chatBox.recentMessage.toLowerCase().contains(query.toLowerCase());
        }).toList();
      });
    }
  }

  void initializeSocket() {
    try {
      _socketService.initializeSocket().then((_) {
        final uid = Provider.of<UserProvider>(context, listen: false).uid;
        _socketService.socket?.emit("new-user-add", uid);
        _socketService.socket?.on("receive-message", (data) async {
          final Map<String, dynamic> messageData = data as Map<String, dynamic>;
          final String? receiverId = messageData['receiverId'];
          final String senderId = messageData['senderId'];
          final String? message = messageData['message'];

          if (receiverId == uid && senderId != uid && message != null) {
            // final chatBoxIndex =
            //     chatBoxes.indexWhere((chatBox) => chatBox.memberId == senderId);
            // if (chatBoxIndex != -1) {
            //   // Update the ChatBox with the new message
            //   setState(() {
            //     chatBoxes[chatBoxIndex].recentMessage = message;
            //     chatBoxes[chatBoxIndex].recentMessageCreatedAt = DateTime.now()
            //         .toIso8601String(); // Update the creation date to now
            //   });
            // }
          }
        });
      });

      // _isSocketInitialized = true;
    } catch (e) {}
  }

  Future<void> refreshChatBox() async {
    if (!isDisposed) {
      setState(() {
        filteredChatBoxes = List.from(chatBoxes);
      });
    }
  }

  Future<void> fetchAndUpdateChats() async {
    try {
      setState(() {
        isLoading = true;
      });
      await fetchChats();
      refreshChatBox();
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

  @override
  void dispose() {
    isDisposed = true;
    _socketService.socket?.disconnect();
    searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchChats();
    // initializeSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => fetchAndUpdateChats(),
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
                          onTap: () => fetchAndUpdateChats(),
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
                          onTap: () => fetchAndUpdateChats(),
                          child: Icon(
                            Icons.refresh, color: primaryColor,
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
