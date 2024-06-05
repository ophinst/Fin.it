import 'package:capstone_project/components/filter_categories.dart';
import 'package:capstone_project/components/found_item_list_card.dart';
import 'package:capstone_project/components/search_bar.dart';
import 'package:capstone_project/models/found_model.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:flutter/material.dart';
import 'package:capstone_project/components/widgets/compose.dart';
import 'package:capstone_project/components/widgets/extd_compose.dart';
import 'package:capstone_project/pages/form_found.dart'; // Make sure to import FormFound

class FoundItemList extends StatefulWidget {
  const FoundItemList({super.key});

  @override
  State<FoundItemList> createState() => _FoundItemListState();
}

class _FoundItemListState extends State<FoundItemList> {
  void foundForm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FormFound(
          onItemAdded: fetchData, // Pass the fetchData function as the callback
        ),
      ),
    );
  }

  List<GetFoundModel> data = [];
  var counter = 1;
  final RemoteService _remoteService = RemoteService();
  bool isLoading = true;
  bool isExtend = false;
  final ScrollController _scrollController = ScrollController();

  String? selectedCategory;
  TextEditingController searchController = TextEditingController();

  fetchData() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<List<GetFoundModel>> fetchedData =
          await _remoteService.fetchFoundItems(
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

  void searchFoundItems(String query) {
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
              'Found Item List',
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
        child: Column(
          children: [
            Row(
              children: [
                const Padding(
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
                const SizedBox(
                  width: 12,
                ),
                SrcBar(
                  searchController: searchController,
                  onSearch: searchFoundItems,
                  size: 137,
                ),
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
            Container(
              margin: const EdgeInsets.only(right: 15),
              child: Row(
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
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        String formattedLocationName = formatLocationName(
                            data[index].placeLocation.locationDetail ??
                                'Unknown location');
                        return FoundItemListCard(
                          foundItem: data[index],
                          formattedLocationName: formattedLocationName,
                          userId: data[index].uid,
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
                foundForm(context);
              },
            )
          : MyExtendedCompose(
              buttonIcon: Icons.edit,
              buttonText: 'New Data',
              onTap: () {
                foundForm(context);
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
                    },
            ),
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
            ),
          ],
        ),
      ),
    );
  }
}
