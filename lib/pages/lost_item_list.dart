import 'package:flutter/material.dart';
import 'package:capstone_project/components/search_bar.dart';
import 'package:flutter/rendering.dart';
import 'package:capstone_project/components/bottom_navbar.dart';
import 'package:capstone_project/components/widgets/compose.dart';
import 'package:capstone_project/components/widgets/extd_compose.dart';
import 'package:capstone_project/components/filter_categories.dart';

class LostItemList extends StatefulWidget {
  const LostItemList({super.key});

  @override
  State<LostItemList> createState() => _LostItemListState();
}

class _LostItemListState extends State<LostItemList> {
  int _currentIndex = 0;
  List imgLostItm = [
    'ip1',
    'ip2',
    'ip3',
    'tws',
    'money',
    'card',
    'wallet',
    'glasses',
  ];

  List nameItem = [
    'Iphone 13 Pro',
    'Iphone 14 Pro',
    'Iphone 15 Pro',
    'Link Buds Pro',
    'Uang banyak',
    'Kartu gacor',
    'Dompet mahal',
    'Kacamata mahal',
  ];

  ScrollController _scrollController = new ScrollController();
  bool isExtend = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 5) {
        setState(() {
          isExtend = true;
        });
      } else {
        setState(() {
          isExtend = false;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 35,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
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
      body: ListView(
          controller: _scrollController,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
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
                //show search bar component
                SrcBar(),
              ],
            ),
            //underline
            Container(
              margin: EdgeInsets.only(left: 25, top: 10, right: 25),
              height: 2,
              color: Colors.black,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    FilterCategories(),   
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: GridView.builder(
                // controller: _scrollController,
                itemCount: imgLostItm.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio:
                        // (MediaQuery.of(context).size.height - 50 - 25),
                        1.0,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              color: Color(0x33000000),
                              offset: Offset(0, 0),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                      child: Column(
                        children: [
                          Container(
                            child: Image.asset(
                              'assets/images/${imgLostItm[index]}.jpeg',
                              width: 100,
                              height: 100,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            nameItem[index],
                            style: TextStyle(
                              // fontFamily: 'JosefinSans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Icon(Icons.location_pin,),
                              Text('Lokasi')
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ]),
      floatingActionButton: isExtend ? buildCompose() : buildExtendedCompose(),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
