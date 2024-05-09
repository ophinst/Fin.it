import 'package:capstone_project/components/my_button.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/models/voucher_model.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:provider/provider.dart';

class VoucherDetail extends StatelessWidget {
  final String rewardId;
  final GetVoucherModel vouchers;
  final RemoteService _remoteService = RemoteService();
  VoucherDetail(
      {required this.rewardId, required this.vouchers, super.key});

  void _redeemVoucher(BuildContext context, String rewardId, String token) async {
  try {
    final response = await _remoteService.purchaseReward(rewardId, token);
    if (response.containsKey('message')) {
      final String message = response['message'];
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
      // Pop to previous page
      Navigator.pop(context);
    } else {
      final String errorMessage = response['error'];
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  } catch (e) {
    // Handle exceptions
    print('Error redeeming voucher: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error redeeming voucher')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String _token = userProvider.token ?? "Unknown";
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
                'Voucher Detail',
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
              height: 25,
            ),
            Center(
              child: Image.network(
                vouchers.rewardImage,
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
                    Text(
                      vouchers.rewardName,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 30,
                        fontFamily: 'JosefinSans',
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(43, 52, 153, 1),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      ('Expireted in ${vouchers.rewardExpiration}'),
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'JosefinSans',
                        color: Color.fromRGBO(43, 52, 153, 1),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 15,
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
                      initialValue: vouchers.rewardDescription,
                      minLines: 3,
                      maxLines: 10,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Enter a description here',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          '${vouchers.rewardPrice} Points',
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () => _redeemVoucher(context, rewardId, _token),
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
                              'Redeem Voucher',
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
