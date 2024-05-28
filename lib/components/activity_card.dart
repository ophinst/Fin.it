import 'package:capstone_project/models/found_model.dart';
import 'package:capstone_project/models/recentact_model.dart';
import 'package:capstone_project/pages/found_item.dart';
import 'package:capstone_project/pages/lost_item.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:capstone_project/models/user_provider.dart';

class ActivityCard extends StatelessWidget {
  final LostAct? lostAct;
  final FoundAct? foundAct;
  final VoidCallback onDelete;
  final Function(bool) setDeleting;

  const ActivityCard({
    this.lostAct,
    this.foundAct,
    required this.onDelete,
    required this.setDeleting,
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

    void deleteItem(String itemId) async {
      setDeleting(true);

      final token = Provider.of<UserProvider>(context, listen: false).token;

      try {
        bool response = await RemoteService().deleteItem(token!, itemId);
        if (response) {
          _showDialog(response, success, 'Item has been deleted!');
          onDelete();
        } else {
          _showDialog(response, failed, 'Failed to delete!');
        }
      } catch (error) {
        print(error);
      } finally {
        setDeleting(false);
      }
    }

    void _showConfirmationDialog(String itemId) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this item?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  deleteItem(itemId);
                },
                child: const Text('Yes'),
              ),
            ],
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
        if (foundAct != null) {
          _navigateToFoundItemPage(foundAct!.foundId);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LostItemPage(lostId: lostAct!.lostId),
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
                          foundAct != null
                              ? "Item Found"
                              : (lostAct != null ? 'Item Lost' : 'No Item Yet'),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        final foundId = foundAct?.foundId;
                        final lostId = lostAct?.lostId;

                        if (foundId != null) {
                          _showConfirmationDialog(foundId);
                        } else if (lostId != null) {
                          _showConfirmationDialog(lostId);
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  foundAct != null
                      ? foundAct!.itemName
                      : (lostAct != null ? lostAct!.itemName : 'No Item Yet'),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(43, 52, 153, 1),
                      fontSize: 26),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  foundAct != null
                      ? foundAct!.locationDetail
                      : (lostAct != null ? lostAct!.locationDetail : ''),
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
                          foundAct != null
                              ? foundAct!.foundDate
                              : (lostAct != null ? lostAct!.lostDate : ''),
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
                          foundAct != null
                              ? foundAct!.foundTime
                              : (lostAct != null ? lostAct!.lostTime : ''),
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
