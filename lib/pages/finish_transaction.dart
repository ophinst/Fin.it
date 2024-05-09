import 'package:capstone_project/models/lost_item_model.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class FinishTransaction extends StatefulWidget {
  final String itemId;
  final String itemName;
  final String itemDate;
  final bool foundUserStatus;
  final bool lostUserStatus;

  FinishTransaction({
    super.key,
    required this.itemId,
    required this.itemName,
    required this.itemDate,
    required this.foundUserStatus,
    required this.lostUserStatus,
  });

  @override
  State<FinishTransaction> createState() => _FinishTransactionState();
}

class _FinishTransactionState extends State<FinishTransaction> {
  final RemoteService _remoteService = RemoteService();

  void finishTrans(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Transaction complete, thank you'),
        duration: Duration(seconds: 2), // Adjust the duration as needed
      ),
    );
    // Navigate back to the homepage after a delay
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  // Function to handle finishing transaction based on item ID
Future<void> finishTransaction(String token) async {
  try {
    if (widget.itemId.startsWith('fou')) {
      // If itemId starts with 'fou'
      dynamic foundItem =
          await _remoteService.getFoundByIdJson(widget.itemId);
      if (foundItem != null) {
        await _remoteService.finishFoundTransaction(
            token, widget.itemId); // Finish found transaction
        // Call finishTrans upon successful completion
        finishTrans(context);
      } else {
        print('Found item not found for ID: ${widget.itemId}');
      }
    } else if (widget.itemId.startsWith('los')) {
      // If itemId starts with 'los'
      Datum? lostItem = await _remoteService.getLostItemById(widget.itemId);
      if (lostItem != null) {
        await _remoteService.finishLostTransaction(
            token, widget.itemId); // Finish lost transaction
        // Call finishTrans upon successful completion
        finishTrans(context);
      } else {
        print('Lost item not found for ID: ${widget.itemId}');
      }
    } else {
      print('Invalid itemId format');
    }
  } catch (e) {
    print('Error finishing transaction: $e');
  }
}


  @override
  void initState() {
    super.initState;
    // print('Found user ${widget.foundUserStatus}');
    // print('Lost user ${widget.lostUserStatus}');
  }

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.only(left: 17, right: 17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 25,
                    top: 25,
                  ),
                  child: Text(
                    'Finish Transaction',
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
            const SizedBox(
              height: 20,
            ),
            Text(
              widget.itemName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'JosefinSans',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.itemDate,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                fontFamily: 'JosefinSans',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text('Found User Status'),
                      const SizedBox(
                        height: 15,
                      ),
                      Icon(
                        Icons.check_circle_rounded,
                        color: widget.foundUserStatus
                            ? Colors.green
                            : Colors.red, // Set color based on foundUserStatus
                      )
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Lost User Status'),
                      const SizedBox(
                        height: 15,
                      ),
                      Icon(
                        Icons.check_circle_rounded,
                        color: widget.lostUserStatus
                            ? Colors.green
                            : Colors.red, // Set color based on lostUserStatus
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                const Text(
                  'Rating User',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'JosefinSans',
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                RatingBar.builder(
                  initialRating: 0,
                  minRating: 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            TextFormField(
              minLines: 3,
              maxLines: 10,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: "Input Feedback....",
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.black, width: 3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                      color: Color.fromRGBO(43, 52, 153, 1), width: 3),
                ),
              ),
              validator: (value) {
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 150) {
                  return 'Must be between 1 and 150 characters';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 350,
        child: FloatingActionButton(
          onPressed: () {
            final token =
                Provider.of<UserProvider>(context, listen: false).token ?? '';
            finishTransaction(token);
          },
          child: const Text(
            'Finish Transaction',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
