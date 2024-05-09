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
  List<ChatBox> filteredChatBoxes =
      []; // List to store filtered ChatBox widgets
  bool _isSocketInitialized = false; // Flag to track socket initialization

  final SocketService _socketService =
      SocketService(); // Use SocketService instance
  IO.Socket? socket;
  RemoteService remoteService = RemoteService();

  var isLoaded = false;
  bool isLoading = false; // Flag to track loading state

  String formatCreatedAt(String createdAt) {
    // Parse the createdAt string into a DateTime object
    final createdAtDateTime = DateTime.parse(createdAt);

    // Calculate the difference between the createdAt time and the current device time
    final difference = DateTime.now().difference(createdAtDateTime);

    // Check if the difference is less than 24 hours
    if (difference.inHours < 24) {
      // Display only the time in hour and minutes
      return '${createdAtDateTime.hour.toString().padLeft(2, '0')}:${createdAtDateTime.minute.toString().padLeft(2, '0')}';
    } else {
      // Display just the date and month
      return '${createdAtDateTime.day.toString().padLeft(2, '0')}-${createdAtDateTime.month.toString().padLeft(2, '0')}';
    }
  }

  Future<void> fetchChats() async {
    try {
      // Set isLoading to true to show circular progress indicator
      setState(() {
        isLoading = true;
      });

      // Retrieve token and user ID from the user provider
      final token = Provider.of<UserProvider>(context, listen: false).token;
      final uid = Provider.of<UserProvider>(context, listen: false).uid;

      // Ensure token is not null before proceeding
      if (token != null) {
        // Call the getChats function with error handling
        final dynamic response =
            await remoteService.getChats(token).catchError((e) {
          throw e; // Rethrow the error to be caught by the outer try-catch block
        });

        // Extract list of chat objects from the response
        final List<dynamic>? chatData = response['data'];

        if (chatData != null) {
          // Clear previous chat boxes
          chatBoxes.clear();
          filteredChatBoxes.clear(); // Clear filtered chat boxes

          // Iterate over chat objects and create or update ChatBox widgets
          for (var chat in chatData) {
            final List<dynamic>? members = chat['members'];

            if (members != null && uid != null) {
              // Filter out member IDs that are not equal to the UID
              final filteredMembers =
                  members.where((memberId) => memberId != uid).toList();

              // Fetch user name and image for the first member ID with error handling
              String memberId = filteredMembers.first;
              String memberName = '';
              String memberImage = '';
              String recentMessage =
                  'Start Chatting Now!'; // Default message when recent message is null
              String recentMessageCreatedAt =
                  '2000-01-01T00:00:00.000Z'; // Default creation date when recent message creation date is null

              if (filteredMembers.isNotEmpty) {
                final user = await remoteService
                    .getUserById(filteredMembers.first)
                    .catchError((e) {
                  throw e; // Rethrow the error to be caught by the outer try-catch block
                });
                if (user != null) {
                  memberName = user.name;
                  memberImage = user.image ??
                      'https://storage.googleapis.com/ember-finit/lostImage/fin-H8xduSgoh6/93419946.jpeg';
                }
              }

              // Get the most recent message and its creation date with error handling
              final List<Message> messagesResponse = await remoteService
                  .getMessages(chat['chatId'])
                  .catchError((e) {
                throw e; // Rethrow the error to be caught by the outer try-catch block
              });
              if (messagesResponse.isNotEmpty) {
                // Sort messages by creation date in descending order
                messagesResponse
                    .sort((a, b) => b.createdAt.compareTo(a.createdAt));

                final Message recentMessageObject = messagesResponse.first;
                if (recentMessageObject.message != null) {
                  recentMessage = recentMessageObject.message!;
                } else if (recentMessageObject.imageUrl != null) {
                  recentMessage = 'Image';
                }
                recentMessageCreatedAt = recentMessageObject.createdAt
                    .toString(); // Format the creation date
              }

              // Fetch item details for the itemId
              final String itemId = chat['itemId'];
              late String itemName =
                  'Loading'; // Default item name while fetching
              late String itemDate = 'Loading';
              if (itemId.startsWith('fou')) {
                // If itemId starts with 'fou', call getFoundByIdJson
                dynamic foundItem =
                    await remoteService.getFoundByIdJson(itemId);
                itemName = foundItem['itemName'] ?? '';
                itemDate = foundItem['foundDate'] ?? '';
              } else if (itemId.startsWith('los')) {
                // If itemId starts with 'los', call getLostItemById
                Datum? lostItem = await remoteService.getLostItemById(itemId);
                if (lostItem != null) {
                  itemName = lostItem.itemName;
                  itemDate = lostItem.lostDate;
                }
              }

              // Check if the chat box already exists
              int existingChatIndex =
                  chatBoxes.indexWhere((box) => box.chatId == chat['chatId']);
              if (existingChatIndex != -1) {
                // Update existing chat box
                setState(() {
                  chatBoxes[existingChatIndex].memberName = memberName;
                  chatBoxes[existingChatIndex].memberImage = memberImage;
                  chatBoxes[existingChatIndex].recentMessage = recentMessage;
                  chatBoxes[existingChatIndex].recentMessageCreatedAt =
                      recentMessageCreatedAt;
                  chatBoxes[existingChatIndex].itemName = itemName;
                  chatBoxes[existingChatIndex].itemDate = itemDate;
                });
              } else {
                // Create new chat box and add it to the list
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
                setState(() {
                  chatBoxes.add(chatBox);
                });
              }
            }
          }

          // Sort chatBoxes based on recentMessageCreatedAt
          chatBoxes.sort((a, b) =>
              b.recentMessageCreatedAt.compareTo(a.recentMessageCreatedAt));

          // Assign chatBoxes to filteredChatBoxes
          setState(() {
            filteredChatBoxes = List.from(chatBoxes);
            isLoaded = true; // Set isLoaded to true
          });
        }
      } else {}
    } catch (e) {
      // Handle errors
    } finally {
      // Set isLoading to false to hide circular progress indicator
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchData() async {
    try {
      // Set isLoading to true to show loading indicator
      setState(() {
        isLoading = true;
      });
      // Fetch chat data
      await fetchChats();
    } catch (e) {
    } finally {
      // Set isLoading to false after fetching data
      setState(() {
        isLoading = false;
      });
    }
  }

  // Search function to filter chat boxes by member name or recent message
  void searchChats(String query) {
    setState(() {
      filteredChatBoxes = chatBoxes.where((chatBox) {
        // Check if the member name or recent message contains the query
        return chatBox.memberName.toLowerCase().contains(query.toLowerCase()) ||
            chatBox.recentMessage.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
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

  void _showInAppNotification(String message, String senderName) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: InAppNotification(message: message, senderName: senderName),
        duration: Duration(seconds: 3), // Adjust duration as needed
      ),
    );
  }

  Future<void> refreshChatBox() async {
    // Refresh the chat box UI based on existing data
    setState(() {
      // Update the filtered chat boxes based on existing chat boxes
      filteredChatBoxes = List.from(chatBoxes);
    });
  }

  Future<void> fetchAndUpdateChats() async {
    try {
      // Set isLoading to true to show loading indicator
      setState(() {
        isLoading = true;
      });
      // Fetch chat data
      await fetchChats();
      // Update chat box UI with newly fetched data
      refreshChatBox();
    } catch (e) {
      // Handle errors
    } finally {
      // Set isLoading to false after fetching and updating data
      setState(() {
        isLoading = false;
      });
    }
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
                        padding: EdgeInsets.only(
                          left: 25,
                          top: 25,
                        ),
                        child: GestureDetector(
                          onTap: () => fetchAndUpdateChats(),
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
                      ),
                      Padding(
                        padding: EdgeInsets.only(
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
