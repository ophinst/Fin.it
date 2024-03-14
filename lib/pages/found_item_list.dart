import 'package:capstone_project/components/found_item_list_card.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/components/search_bar.dart';
import 'package:capstone_project/components/widgets/compose.dart';
import 'package:capstone_project/components/widgets/extd_compose.dart';
import 'package:capstone_project/components/filter_categories.dart';

class FoundItemList extends StatefulWidget {
  const FoundItemList({super.key});

  @override
  State<FoundItemList> createState() => _FoundItemListState();
}

class _FoundItemListState extends State<FoundItemList> {
  void lostForm(BuildContext context) {
    // Navigate to the HomePage
    Navigator.pushNamed(context, '/add-lost');
  }

  bool isExtend = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 35,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Text(
              'LOST & FOUND',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'JosefinSans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: 25,
                  top: 25,
                ),
                child: Text(
                  'Found Something?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'JosefinSans',
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              // SrcBar(),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
            height: 2,
            color: Colors.black,
          ),
          const SizedBox(
            height: 10,
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  // FilterCategories(),
                ],
              ),
            ],
          ),
          const FoundItemListCard(),
        ],
      ),
      floatingActionButton: isExtend
          ? MyCompose(
              onTap: () {
                lostForm(context);
              },
            )
          : MyExtendedCompose(
              onTap: () {
                lostForm(context);
              },
            ),
    );
  }
}
