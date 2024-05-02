import 'package:capstone_project/models/recentact_model.dart';

import 'package:flutter/material.dart';

class ActivityCard extends StatelessWidget {
  final LostAct? lostAct;
  final FoundAct? foundAct;

  const ActivityCard(
      {required this.lostAct, required this.foundAct, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   if (foundItem.foundId != null) {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => FoundItemPage(
      //           foundItem: foundItem,
      //           foundId: foundItem.foundId,
      //         ),
      //       ),
      //     );
      //   } else {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => LostItemPage(
      //           lostId: lostItem.lostId,
      //         ),
      //       ),
      //     );
      //   }
      // },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: Column(
            children: [
              Text(
                foundAct != null
                    ? foundAct!.itemName
                    : (lostAct != null ? lostAct!.itemName : ''),
                style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
