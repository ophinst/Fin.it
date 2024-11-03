import 'package:capstone_project/models/found_model.dart';
import 'package:capstone_project/models/item_model.dart';
import 'package:capstone_project/pages/found_item.dart';
import 'package:capstone_project/pages/lost_item.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final ItemModel item;

  const ItemCard({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const success = 'assets/images/success.png';
    const failed = 'assets/images/fail.png';

    void _showDialog(bool status, String image, String text) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(image),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    text,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    void _navigateToFoundItemPage(String foundId) async {
      try {
        var result = await RemoteService().getFoundByIdJson(foundId);
        if (result['status'] == 200) {
          var foundItem = GetFoundModel.fromJson(result['data']);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FoundItemPage(
                foundItem: foundItem,
                foundId: foundId,
              ),
            ),
          );
        } else {
          _showDialog(false, failed, result['message']);
        }
      } catch (error) {
        _showDialog(false, failed, 'Error: $error');
      }
    }

    return GestureDetector(
      onTap: () {
        if (item.foundId != null) {
          _navigateToFoundItemPage(item.foundId!);
        } else if (item.lostId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LostItemPage(lostId: item.lostId!),
            ),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.search,
                          size: 30,
                          color: Color.fromRGBO(43, 52, 153, 1),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          item.foundId != null ? 'Found Item' : 'Lost Item',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  item.itemName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(43, 52, 153, 1),
                      fontSize: 26),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  item.locationDetail,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month,
                          color: Color.fromRGBO(43, 52, 153, 1),
                          size: 25,
                        ),
                        Text(
                          item.foundDate ?? item.lostDate ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_sharp,
                          color: Color.fromRGBO(43, 52, 153, 1),
                          size: 25,
                        ),
                        Text(
                          item.foundTime ?? item.lostTime ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
