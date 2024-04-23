import 'package:capstone_project/models/found_model.dart';
import 'package:flutter/material.dart';

class FoundItemListCard extends StatelessWidget {
  final GetFoundModel foundItem;
  const FoundItemListCard({required this.foundItem, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.album,
                  size: 35,
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(foundItem.foundOwner),
                    Text(foundItem.foundDate),
                  ],
                ),
                subtitle: Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: SizedBox(
                    height: 70,
                    child: Center(child: Text(foundItem.itemDescription)),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 64),
                    child: Expanded(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: Color.fromRGBO(43, 52, 153, 1),
                          ),
                          Text(foundItem.placeLocation.locationDetail),
                        ],
                      ),
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
