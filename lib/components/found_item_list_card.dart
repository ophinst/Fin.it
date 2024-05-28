import 'package:capstone_project/models/found_model.dart';
import 'package:capstone_project/models/user_model.dart';
import 'package:capstone_project/pages/found_item.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter/material.dart';

class FoundItemListCard extends StatefulWidget {
  final GetFoundModel foundItem;
  final String? formattedLocationName;
  final String userId;

  const FoundItemListCard(
      {required this.foundItem,
      required this.formattedLocationName,
      required this.userId,
      super.key});

  @override
  State<FoundItemListCard> createState() => _FoundItemListCardState();
}

class _FoundItemListCardState extends State<FoundItemListCard> {
  User? user;

  @override
  void initState() {
    super.initState();
    fetchUser();
  }

  Future<void> fetchUser() async {
    try {
      final fetchedUser = await RemoteService().getUserById(widget.userId);
      setState(() {
        user = fetchedUser;
      });
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    print(widget.userId);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoundItemPage(
              foundItem: widget.foundItem,
              foundId: widget.foundItem.foundId,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            children: [
              ListTile(
                leading: user?.image != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(user!.image!),
                      )
                    : const Icon(
                        Icons.album,
                        size: 35,
                      ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.foundItem.itemName),
                    Text(widget.foundItem.foundDate),
                  ],
                ),
                subtitle: Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: SizedBox(
                    height: 70,
                    child: Center(child: Text(widget.foundItem.itemDescription)),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 64),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color.fromRGBO(43, 52, 153, 1),
                        ),
                        Text(
                          widget.formattedLocationName ??
                              widget.foundItem.placeLocation.locationDetail ??
                              'Location detail is not available',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
