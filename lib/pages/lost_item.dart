import 'package:capstone_project/models/lost_item_model.dart';
import 'package:capstone_project/models/user_model.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/pages/chat/conversation_page.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../models/chat_model.dart';

class LostItemPage extends StatefulWidget {
  final String? lostId;
  // final LostItem? lostItem;

  const LostItemPage({Key? key, required this.lostId}) : super(key: key);

  @override
  State<LostItemPage> createState() => _LostItemPageState();
}

class _LostItemPageState extends State<LostItemPage> {
  late Future<Datum?> _lostItemFuture;
  RemoteService _remoteService = RemoteService();

  @override
  void initState() {
    super.initState();
    _lostItemFuture = RemoteService().getLostItemById(widget.lostId!);
  }

  void tagButton() {}

  void chatButton(BuildContext? context, Datum? lostItem) async {
  if (context == null || lostItem == null) {
    // Handle the case when the context or lostItem is null
    return;
  }

  try {
    // Get user data
    User? user = await _remoteService.getUserById(lostItem.uid);
    String userName = user?.name ?? 'Unknown User';
    String userImage = user?.image ?? 'https://storage.googleapis.com/ember-finit/lostImage/fin-3lMxkshfQx/camunda%20logo.png';

    // Get token from userProvider
    final token = Provider.of<UserProvider?>(context, listen: false)?.token ?? ''; // Assign empty string if token is null

    // Call getChatById function
    String itemId = lostItem.lostId; // Using foundId instead of lostId
    String receiverId = lostItem.uid; // Assuming foundItem is available
    Map<String, dynamic> chatData = await _remoteService.getChatById(token, itemId, receiverId);

    // Access the 'data' field from chatData
    Map<String, dynamic>? chatInfo = chatData['data'];

    if (chatInfo != null) {
      // Create Chat object from the chatInfo map
      Chat chat = Chat.fromJson(chatInfo);

      // Navigate to ConversationPage
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConversationPage(
            chatId: chat.chatId,
            memberId: lostItem.uid,
            memberName: userName,
            memberImage: userImage,
            itemId: lostItem.lostId,
            itemName: lostItem.itemName,
          ),
        ),
      );
      
    } else {
      print('Error: No chat data found in the response.');
    }
  } catch (e) {
    print('Error: $e');
  }
}


  // int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Colors.white;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: primaryColor,
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Center(
              child: Text(
                'LOST ITEM',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'JosefinSans',
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
        elevation: 0,
      ),
      body: FutureBuilder<Datum?>(
        future: _lostItemFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            Datum? lostItem = snapshot.data;
            if (lostItem == null) {
              return Center(
                child: Text('No data found'),
              );
            } else {
              return SingleChildScrollView(
                controller: ScrollController(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Image.network(
                        lostItem.itemImage,
                        height: 200,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nama barang:',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'JosefinSans',
                                color: Color.fromRGBO(43, 52, 153, 1),
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              lostItem.itemName,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'JosefinSans',
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'Nama penemu:',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'JosefinSans',
                                color: Color.fromRGBO(43, 52, 153, 1),
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              lostItem.lostOwner,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'JosefinSans',
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_month,
                                      color: Color.fromRGBO(43, 52, 153, 1),
                                      size: 35,
                                    ),
                                    Text(
                                      '${lostItem.lostDate}',
                                      style: TextStyle(
                                          fontFamily: 'JosefinSans',
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.timer_sharp,
                                      color: Color.fromRGBO(43, 52, 153, 1),
                                      size: 35,
                                    ),
                                    Text(
                                      '${lostItem.lostTime}',
                                      style: TextStyle(
                                          fontFamily: 'JosefinSans',
                                          fontSize: 15),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: Card(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: SizedBox(
                                        height: 200,
                                        // width: 100,
                                        child: GoogleMap(
                                          mapType: MapType.normal,
                                          initialCameraPosition: CameraPosition(
                                              target: LatLng(
                                                lostItem.latitude,
                                                lostItem.longitude,
                                              ),
                                              zoom: 14),
                                          markers: {
                                            Marker(
                                              markerId: const MarkerId(
                                                  'lostItemMarker'),
                                              position: LatLng(
                                                lostItem.latitude,
                                                lostItem.longitude,
                                              ),
                                              infoWindow: InfoWindow(
                                                title: lostItem.itemName,
                                                snippet:
                                                    'This is the location of the lost item',
                                              ),
                                            ),
                                          },
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_pin,
                                          color: Color.fromRGBO(43, 52, 153, 1),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.8,
                                          child: FutureBuilder<String>(
                                            future: RemoteService()
                                                .getLocationName(
                                                    lostItem.latitude,
                                                    lostItem.longitude),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return Text('Loading...');
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else {
                                                String locationName =
                                                    snapshot.data!;
                                                return Text(
                                                  locationName,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                );
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            const Text(
                              'Deskripsi :',
                              style: TextStyle(
                                fontFamily: 'JosefinSans',
                                color: Color.fromRGBO(
                                  43,
                                  52,
                                  153,
                                  1,
                                ),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              initialValue: lostItem.itemDescription,
                              minLines: 3,
                              maxLines: 10,
                              keyboardType: TextInputType.multiline,
                              decoration: const InputDecoration(
                                hintText: 'Enter a description here',
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton(
                                  onPressed: tagButton,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(43, 52, 153, 1),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                      left: 20.0,
                                      right: 20.0,
                                    ),
                                    child: Text(
                                      'TAG',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () => chatButton(context,lostItem),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromRGBO(43, 52, 153, 1),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 10.0,
                                      left: 18.0,
                                      right: 18.0,
                                    ),
                                    child: Text(
                                      'CHAT',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }
        },
      ),
    );
  }
}
