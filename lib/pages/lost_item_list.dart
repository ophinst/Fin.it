import 'package:capstone_project/models/lost_item_model.dart';
import 'package:capstone_project/pages/lost_item.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/components/search_bar.dart';
import 'package:capstone_project/components/widgets/compose.dart';
import 'package:capstone_project/components/widgets/extd_compose.dart';
import 'package:capstone_project/components/filter_categories.dart';

class LostItemList extends StatefulWidget {
  const LostItemList({super.key});

  @override
  State<LostItemList> createState() => _LostItemListState();
}

class _LostItemListState extends State<LostItemList> {
  final RemoteService _remoteService = RemoteService();
  List<Datum> data = [];
  var counter = 1;
  var isLoading = true;
  bool isExtend = false;

  String? selectedCategory;

  TextEditingController searchController = TextEditingController();

  void lostForm(BuildContext context) {
    Navigator.pushNamed(context, '/add-lost');
  }

  fetchData() async {
    try {
      setState(() {
        isLoading = true;
      });
      List<List<Datum>> fetchedData =
          await _remoteService.getLostItems(counter);
      setState(() {
        data = fetchedData[0];
        if (fetchedData[1].isEmpty) {
          isExtend = false;
        } else {
          isExtend = true;
        }
      });
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  // List<Datum>? filterLostsByCategory(String? category) {
  //   if (category == null || category.isEmpty) {
  //     return allLosts; // Return all lost items if no category is selected
  //   }
  //   return allLosts?.where((item) => item.category == category).toList();
  // }

  // void searchLostItems(String query) {
  //   List<Datum> searchResult = allLosts!
  //       .where((lostItem) =>
  //           lostItem.itemName.toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  //   setState(() {
  //     displayedLosts = searchResult;
  //   });
  // }

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
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
              //show search bar component
              // SrcBar(
              //   searchController: searchController,
              //   onSearch: searchLostItems,
              // ),
            ],
          ),
          //underline
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
                  // FilterCategories(
                  //   onCategoryChanged: handleCategoryChanged,
                  // ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    itemCount: data.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.0,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10),
                    itemBuilder: (context, index) {
                      final latitude = data[index].latitude;
                      final longitude = data[index].longitude;
                      final lostId = data[index].lostId;
                      return FutureBuilder<String>(
                        future: RemoteService()
                            .getLocationName(latitude, longitude),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            final locationName = snapshot.data;
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LostItemPage(
                                      lostId: lostId,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                decoration: BoxDecoration(
                                    boxShadow: const [
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
                                    Image.network(
                                      data[index].itemImage,
                                      width: 100,
                                      height: 100,
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        }
                                      },
                                      errorBuilder: (BuildContext context,
                                          Object exception,
                                          StackTrace? stackTrace) {
                                        return const Text(
                                            'Failed to load image');
                                      },
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      data[index].itemName,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 1),
                                    Row(
                                      children: [
                                        const Icon(Icons.location_pin),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            locationName ??
                                                'Location not found',
                                            style:
                                                const TextStyle(fontSize: 12),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: isLoading || counter <= 1
                    ? null
                    : () {
                        setState(() {
                          counter--;
                        });
                        fetchData();
                      }),
            Text(
              'Page $counter',
              style: const TextStyle(fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: isLoading || !isExtend
                  ? null
                  : () {
                      setState(() {
                        counter++;
                      });
                      fetchData();
                    },
            ), // Display the icon without an onPressed function
          ],
        ),
      ),
    );
  }
}
