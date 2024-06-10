import 'package:capstone_project/models/lost_item_model.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter/material.dart';
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
      Navigator.popAndPushNamed(context, '/home');
    });
  }

  // Function to handle finishing transaction based on item ID
  Future<void> finishTransaction(String token) async {
    try {
      if (widget.itemId.startsWith('fou')) {
        dynamic foundItem =
            await _remoteService.getFoundByIdJson(widget.itemId);
        if (foundItem != null) {
          await _remoteService.finishFoundTransaction(
              token, widget.itemId); // Finish found transaction
          finishTrans(context); // Call finishTrans upon successful completion
        } else {
          print('Found item not found for ID: ${widget.itemId}');
        }
      } else if (widget.itemId.startsWith('los')) {
        Datum? lostItem = await _remoteService.getLostItemById(widget.itemId);
        if (lostItem != null) {
          await _remoteService.finishLostTransaction(
              token, widget.itemId); // Finish lost transaction
          finishTrans(context); // Call finishTrans upon successful completion
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

  // Function to show confirmation dialog
  Future<void> _showConfirmationDialog(String image, String text) async {
    return showDialog<void>(
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
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        final token =
                            Provider.of<UserProvider>(context, listen: false)
                                    .token ??
                                '';
                        finishTransaction(token);
                      },
                      child: const Text('Yes'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
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
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
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
          ],
        ),
      ),
      floatingActionButton: Container(
        width: 350,
        child: FloatingActionButton(
          onPressed: () {
            _showConfirmationDialog('assets/images/tandatanya.png',
                'Are you sure you want to finish this transaction?');
          },
          backgroundColor: const Color.fromRGBO(43, 52, 153, 1),
          child: const Text(
            'Finish Transaction',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
