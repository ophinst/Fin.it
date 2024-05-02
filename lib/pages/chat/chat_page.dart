import 'package:capstone_project/models/lost_item_model.dart';
import 'package:capstone_project/models/message_model.dart';
import 'package:capstone_project/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/components/chat_box.dart';
import 'package:capstone_project/components/search_bar.dart';
import 'package:capstone_project/services/remote_service.dart';
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

  final SocketService _socketService = SocketService(); // Use SocketService instance
  IO.Socket? socket;

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

  // Define a callback function that calls fetchChats
  void onChatPageRefresh() {
    fetchChats();
  }

  Future<void> fetchChats() async {
  try {
    // Check if data has already been loaded
    if (isLoaded) {
      // If data has been loaded, use cached data
      setState(() {
        filteredChatBoxes = List.from(chatBoxes);
        isLoading = false;
      });
      return;
    }

    // Set isLoading to true to show circular progress indicator
    setState(() {
      isLoading = true;
    });

    // Retrieve token and user ID from the user provider
    final token = Provider.of<UserProvider>(context, listen: false).token;
    final uid = Provider.of<UserProvider>(context, listen: false).uid;

    // Ensure token is not null before proceeding
    if (token != null) {
      // Create an instance of RemoteService
      RemoteService remoteService = RemoteService();

      // Call the getChats function with error handling
      final dynamic response = await remoteService.getChats(token).catchError((e) {
        throw e; // Rethrow the error to be caught by the outer try-catch block
      });

      // Extract list of chat objects from the response
      final List<dynamic>? chatData = response['data'];


      if (chatData != null) {
        // Clear previous chat boxes
        setState(() {
          chatBoxes.clear();
          filteredChatBoxes.clear(); // Clear filtered chat boxes
        });

        // Iterate over chat objects and create ChatBox widgets
        for (var chat in chatData) {
          final List<dynamic>? members = chat['members'];

          if (members != null && uid != null) {
            // Filter out member IDs that are not equal to the UID
            final filteredMembers = members.where((memberId) => memberId != uid).toList();

            // Fetch user name and image for the first member ID with error handling
            String memberId = filteredMembers.first;
            String memberName = '';
            String memberImage = '';
            String recentMessage = '';
            String recentMessageCreatedAt = '';

            if (filteredMembers.isNotEmpty) {
              final user = await remoteService.getUserById(filteredMembers.first).catchError((e) {
                throw e; // Rethrow the error to be caught by the outer try-catch block
              });
              if (user != null) {
                // print(user.reward);
                memberName = user.name;
                memberImage = user.image ??
                    'https://storage.googleapis.com/ember-finit/lostImage/fin-H8xduSgoh6/93419946.jpeg';
              }
            }

            // Get the most recent message and its creation date with error handling
            final List<Message> messagesResponse = await remoteService.getMessages(chat['chatId']).catchError((e) {
              throw e; // Rethrow the error to be caught by the outer try-catch block
            });
            if (messagesResponse.isNotEmpty) {
              // Sort messages by creation date in descending order
              messagesResponse.sort((a, b) => b.createdAt.compareTo(a.createdAt));

              final Message recentMessageObject = messagesResponse.first;
              if (recentMessageObject.message != null) {
                recentMessage = recentMessageObject.message!;
              } else if (recentMessageObject.imageUrl != null) {
                recentMessage = 'Image';
              }
              recentMessageCreatedAt = recentMessageObject.createdAt.toString(); // Format the creation date
            }

            // Fetch item details for the itemId
            final String itemId = chat['itemId'];
            late String itemName = 'Loading'; // Default item name while fetching
            late String itemDate = 'Loading'; 
            if (itemId.startsWith('fou')) {
              // If itemId starts with 'fou', call getFoundByIdJson
              dynamic foundItem = await remoteService.getFoundByIdJson(itemId);
              setState(() {
                itemName = foundItem['itemName'] ?? '';
                itemDate = foundItem['foundDate'] ?? '';
              });
            } else if (itemId.startsWith('los')) {
              // If itemId starts with 'los', call getLostItemById
              Datum? lostItem = await remoteService.getLostItemById(itemId);
              if (lostItem != null) {
                setState(() {
                  itemName = lostItem.itemName;
                  itemDate = lostItem.lostDate;
                });
              } else {
              }
            } else {
            }

            // Create ChatBox widget with chat ID, member name, member image, recent message, and creation date
            final chatBox = ChatBox(
              chatId: chat['chatId'],
              memberId: memberId,
              memberName: memberName,
              memberImage: memberImage,
              recentMessage: recentMessage,
              recentMessageCreatedAt: recentMessageCreatedAt,
              itemId: itemId,
              itemName: itemName, // Pass the fetched item name here
              itemDate: itemDate,
              updateRecentMessage: (message) {
                // Define the updateRecentMessage function here
                setState(() {
                  recentMessage = message;
                });
              },
            );

            // Add chatBox to chatBoxes list
            chatBoxes.add(chatBox);
          }
        }

        // Sort chatBoxes based on recentMessageCreatedAt
        chatBoxes.sort((a, b) => b.recentMessageCreatedAt.compareTo(a.recentMessageCreatedAt));

        // Assign chatBoxes to filteredChatBoxes
        setState(() {
          filteredChatBoxes = List.from(chatBoxes);
          isLoaded = true; // Set isLoaded to true
        });
      } else {
      }
    } else {
    }
  } catch (e) {
  } finally {
    // Set isLoading to false to hide circular progress indicator
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
        _socketService.socket?.on("receive-message", (data) {
          final Map<String, dynamic> messageData = data as Map<String, dynamic>;
          final String? receiverId = messageData['receiverId'];
          final String? senderId = messageData['senderId'];
          final String? message = messageData['message'];

          if (receiverId == uid && senderId != uid && message != null) {
            setState(() {
              // Find the ChatBox with memberId equal to senderId
              final chatBoxToUpdate = chatBoxes.firstWhere(
                (chatBox) => chatBox.memberId == senderId,
                orElse: () => ChatBox(
                  chatId: '', // Provide default values here
                  memberId: '',
                  memberName: '',
                  memberImage: '',
                  recentMessage: '',
                  recentMessageCreatedAt: '',
                  itemId: '',
                  itemName: '',
                  itemDate: '',
                  updateRecentMessage: (_) {}, // No-op function
                ),
              );

              // Update the recent message in the found ChatBox
              chatBoxToUpdate.updateRecentMessage(message);
            });
          }
        });
      });
    } catch (e) {
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

  @override
  void initState() {
    super.initState();
    fetchData();
    // initializeSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => fetchData(),
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
                  isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          children: [
                            for (var chatBox in filteredChatBoxes)
                              Column(
                                children: [
                                  chatBox,
                                  const SizedBox(
                                      height:
                                          10), // Add SizedBox between ChatBoxes
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
