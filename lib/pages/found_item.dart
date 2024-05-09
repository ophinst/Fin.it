import 'package:capstone_project/models/chat_model.dart';
import 'package:capstone_project/models/place.dart';
import 'package:capstone_project/models/user_model.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/pages/chat/conversation_page.dart';
import 'package:capstone_project/pages/map.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:capstone_project/models/found_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FoundItemPage extends StatelessWidget {
  final String foundId;
  final GetFoundModel foundItem;

  FoundItemPage({required this.foundItem, required this.foundId, super.key});

  final RemoteService _remoteService = RemoteService();

  void tagButton() {}
  void chatButton(BuildContext? context) async {
    if (context == null) {
      // Handle the case when the context is null
      return;
    }

    try {
      // Get user data
      User? user = await _remoteService.getUserById(foundItem.uid);
      String userName = user?.name ?? 'Unknown User';
      String userImage = user?.image ??
          'https://storage.googleapis.com/ember-finit/lostImage/fin-H8xduSgoh6/93419946.jpeg';

      // Get token from userProvider
      final token = Provider.of<UserProvider?>(context, listen: false)?.token ??
          ''; // Assign empty string if token is null

      // Call getChatById function
      String itemId = foundItem.foundId;
      String receiverId = foundItem.uid;
      Map<String, dynamic> chatData =
          await _remoteService.getChatById(token, itemId, receiverId);

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
              memberId: foundItem.uid,
              memberName: userName,
              memberImage: userImage,
              itemId: foundItem.foundId,
              itemName: foundItem.itemName,
              itemDate: foundItem.foundDate,
            ),
          ),
        );
      } else {
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider?>(context);
    String apiKey = dotenv.env['GOOGLE_MAPS_API_KEY']!;
    bool isCurrentUser =
        userProvider != null && foundItem.uid == userProvider.uid;
    Color primaryColor = Colors.white;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
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
                'FOUND ITEM',
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
      body: SingleChildScrollView(
        controller: ScrollController(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              // width: MediaQuery.of(context).size.width * 1,
              // height: 532,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
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
                      foundItem.itemName,
                      style: const TextStyle(
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
                      foundItem.foundOwner,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'JosefinSans',
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
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
                    Text(
                      foundItem.itemDescription, // Display the description here
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_month,
                              color: Color.fromRGBO(43, 52, 153, 1),
                              size: 35,
                            ),
                            Text(
                              foundItem.foundDate,
                              style: const TextStyle(
                                  fontFamily: 'JosefinSans', fontSize: 15),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.timer_sharp,
                              color: Color.fromRGBO(43, 52, 153, 1),
                              size: 35,
                            ),
                            Text(
                              foundItem.foundTime,
                              style: const TextStyle(
                                  fontFamily: 'JosefinSans', fontSize: 15),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: 135,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 10,
                              color: Color(0x33000000),
                              offset: Offset(0, 0),
                            )
                          ],
                          borderRadius: BorderRadius.circular(7),
                        ),
                        child: Stack(
                          children: [
                            const Align(
                              alignment: AlignmentDirectional(0, -0.9),
                              child: Text(
                                'Last Location!',
                                style: TextStyle(
                                    fontFamily: 'JosefinSans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromRGBO(43, 52, 153, 1)),
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(-0.10, 0.9),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_pin,
                                    color: Color.fromRGBO(43, 52, 153, 1),
                                  ),
                                  Text(
                                    foundItem.placeLocation.locationDetail !=
                                            null
                                        ? (foundItem.placeLocation
                                                    .locationDetail!.length >
                                                40
                                            ? '${foundItem.placeLocation.locationDetail!.substring(0, 40)}...'
                                            : foundItem
                                                .placeLocation.locationDetail!)
                                        : 'Location detail not available',
                                    style: const TextStyle(
                                      fontFamily: 'JosefinSans',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0, 0),
                              child: Container(
                                width: 333,
                                height: 73,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 300, // Adjust height as needed
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => MapScreen(
                                            location: PlaceLocation(
                                              latitude: foundItem
                                                  .placeLocation.latitude,
                                              longitude: foundItem
                                                  .placeLocation.longitude,
                                              locationDetail: foundItem
                                                  .placeLocation.locationDetail,
                                            ),
                                            isSelecting:
                                                false, // Disable selecting if just viewing
                                          ),
                                        ),
                                      );
                                    },
                                    child: Image.network(
                                      'https://maps.googleapis.com/maps/api/staticmap?center=${foundItem.placeLocation.latitude},${foundItem.placeLocation.longitude}&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C${foundItem.placeLocation.latitude},${foundItem.placeLocation.longitude}&key=$apiKey',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
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
                        if (!isCurrentUser)
                          ElevatedButton(
                            onPressed: () => chatButton(context),
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
      ),
    );
  }
}
