import 'package:capstone_project/components/filter_categories.dart';
import 'package:capstone_project/components/lost_item_list_card.dart';
import 'package:capstone_project/components/search_bar.dart';
import 'package:capstone_project/models/lost_item_model.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/components/widgets/compose.dart';
import 'package:capstone_project/components/widgets/extd_compose.dart';

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
  final ScrollController _scrollController = ScrollController();

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
    List<List<Datum>> fetchedData = await _remoteService.getLostItems(
      counter: counter,
      search: searchController.text,
      category: selectedCategory,
    );
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

void searchLostItems(String query) {
  setState(() {
    counter = 1; // Reset to first page on search
  });
  fetchData();
}

void handleCategoryChanged(String? category) {
  setState(() {
    selectedCategory = category;
    counter = 1; // Reset to first page on category change
  });
  fetchData();
}

  String formatLocationName(String locationName, {int maxLength = 35}) {
    if (locationName.length <= maxLength) {
      return locationName;
    }
    return '${locationName.substring(0, maxLength)}...';
  }

  Future<void> _refreshPage() async {
    fetchData();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _scrollController.addListener(() {
      if (_scrollController.offset > 15) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Text(
              'Lost Item List',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'JosefinSans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: ListView(
          controller: _scrollController,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: 25,
                    top: 25,
                  ),
                  child: Text(
                    'Lost Something?',
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
                SrcBar(
                  searchController: searchController,
                  onSearch: searchLostItems,
                ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    FilterCategories(
                      onCategoryChanged: handleCategoryChanged,
                    ),
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
                        String formattedLocationName = formatLocationName(
                          data[index].locationDetail
                        );
                        return LostItemListCard(
                          lostItem: data[index],
                          formattedLocationName: formattedLocationName,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: isExtend
          ? MyCompose(
              buttonIcon: Icons.edit,
              onTap: () {
                lostForm(context);
              },
            )
          : MyExtendedCompose(
              buttonIcon: Icons.edit,
              buttonText: 'New Data',
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
