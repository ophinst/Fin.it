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
      //   if (foundAct?.foundId != null) {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => FoundItemPage(
      //           foundId: foundAct!.foundId,
      //         ),
      //       ),
      //     );
      //   } else if (lostAct?.lostId != null) {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => LostItemPage(
      //           lostId: lostAct!.lostId,
      //         ),
      //       ),
      //     );
      //   } else {
      //     Text('no data');
      //   }
      // },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.search,
                      size: 30,
                      color: Color.fromRGBO(43, 52, 153, 1),
                    ),
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
