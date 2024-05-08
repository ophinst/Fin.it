import 'package:flutter/material.dart';
import 'package:capstone_project/models/userVoucher_model.dart';

class MyVoucherCard extends StatelessWidget {
  // final UserData? userData;
  final Voucher? userVoucher;
  // final OwnedRewardCode? userCode;

  const MyVoucherCard(
      {required this.userVoucher,
      // required this.userData,
      // required this.userCode,
      super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Image.network(
                      userVoucher != null
                          ? userVoucher!.rewardImage
                          : 'No image',
                      width: 50,
                      height: 50,
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
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userVoucher != null
                              ? userVoucher!.rewardName
                              : 'No item',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 23,
                          ),
                        ),
                        Text(
                          userVoucher != null
                              ? 'Valid thru ${userVoucher!.rewardExpiration}'
                              : 'No item',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Container(
                        width: constraints
                            .maxWidth, // This makes the Container's width match the parent's width
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(217, 217, 217, 1),
                          borderRadius: BorderRadius.circular(
                              7), // Adjust the radius as needed
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(
                              8.0), // Optional: Adds some padding inside the container
                          child: Center(
                            child: SelectableText(
                              userVoucher != null
                                  ? userVoucher!.ownedRewardCode.rewardCode
                                      .join('\n')
                                  : 'No item',
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.black,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
