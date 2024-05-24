import 'package:capstone_project/models/lost_item_model.dart';
import 'package:capstone_project/pages/lost_item.dart';
import 'package:flutter/material.dart';

class LostItemListCard extends StatelessWidget {
  final Datum lostItem;
  final String formattedLocationName;

  const LostItemListCard(
      {required this.lostItem, required this.formattedLocationName, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LostItemPage(lostId: lostItem.lostId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x33000000),
            offset: Offset(0, 0),
          ),
        ], borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: Column(
          children: [
            Image.network(
              lostItem.itemImage,
              width: 100,
              height: 100,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                }
              },
              errorBuilder: (BuildContext context, Object exception,
                  StackTrace? stackTrace) {
                return const Text('Failed to load image');
              },
            ),
            const SizedBox(height: 5),
            Text(
              lostItem.itemName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 1),
            Row(
              children: [
                const Icon(Icons.location_pin),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    formattedLocationName,
                    style: const TextStyle(fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
