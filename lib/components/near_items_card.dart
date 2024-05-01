import 'package:capstone_project/models/near_items_model.dart';
import 'package:flutter/material.dart';

class NearItemsCard extends StatelessWidget {
  final FoundNearItem? foundNearItems;
  final LostNearItem? lostNearItems;
  const NearItemsCard({this.foundNearItems, this.lostNearItems, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Column(
                      //   children: [
                      //     Image.asset(
                      //       'assets/images/iphone.jpg',
                      //       width: 75,
                      //       height: 100,
                      //       fit: BoxFit.cover,
                      //     ),
                      //   ],
                      // ),
                      const SizedBox(
                        width: 15,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            foundNearItems != null
                                ? foundNearItems!.itemName
                                : (lostNearItems != null
                                    ? lostNearItems!.itemName
                                    : ''),
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 16),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            foundNearItems != null
                                ? foundNearItems!.locationDetail.length <= 17
                                    ? foundNearItems!.locationDetail
                                    : '${foundNearItems!.locationDetail.substring(0, 17)}...'
                                : (lostNearItems != null
                                    ? lostNearItems!.locationDetail.length <= 17
                                        ? lostNearItems!.locationDetail
                                        : '${lostNearItems!.locationDetail.substring(0, 17)}...'
                                    : ''),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            foundNearItems != null
                                ? '${foundNearItems!.foundDate}, ${foundNearItems!.foundTime}'
                                : (lostNearItems != null
                                    ? '${lostNearItems!.lostDate}, ${lostNearItems!.lostTime}'
                                    : 'Undefined date & time'),
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 35,
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Status',
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.incomplete_circle,
                                color: Colors.black,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
