import 'package:flutter/material.dart';
import 'package:capstone_project/models/voucher_model.dart';
import 'package:capstone_project/services/remote_service.dart';

class VoucherDetail extends StatelessWidget {
  final String rewardId;
  final GetVoucherModel vouchers;
  const VoucherDetail(
      {required this.rewardId, required this.vouchers, super.key});

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
                      style: TextStyle(
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
                      style: TextStyle(
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
                    const SizedBox(
                      height: 20.0,
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
