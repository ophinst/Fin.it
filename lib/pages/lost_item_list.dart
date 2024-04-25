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
  void foundForm(BuildContext context) {
    // Navigate to the HomePage
    Navigator.pushNamed(context, '/add-found');
  }

  List<Datum>? allLosts; // Store all the fetched data
  List<Datum>? displayedLosts; // Store the currently displayed page data
  var isLoaded = false;

  final ScrollController _scrollController = ScrollController();
  bool isExtend = false;

  int currentPage = 1;
  int itemsPerPage = 10; // Number of items per page

  String? selectedCategory;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedCategory = items[0];
    //fetch data from API
    getData();

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

  void getData() async {
    var data = await RemoteService().getLostItems();
    if (mounted) {
      setState(() {
        isLoaded = true;
        allLosts = data;
        // Initialize displayedLosts with allLosts
        displayedLosts = allLosts;
        // Reset currentPage when data changes
        currentPage = 1;
        // Adjust displayedLosts based on currentPage and itemsPerPage
        updateDisplayedLosts();
      });
    }
    // Filter lost items by category
    filterLostsByCategory(selectedCategory);
  }

  List<Datum>? filterLostsByCategory(String? category) {
    if (category == null || category.isEmpty) {
      return allLosts; // Return all lost items if no category is selected
    }
    return allLosts?.where((item) => item.category == category).toList();
  }

  void updateDisplayedLosts() {
    int startIndex = (currentPage - 1) * itemsPerPage;
    int endIndex = currentPage * itemsPerPage;
    // Ensure endIndex is within the bounds of displayedLosts
    if (endIndex > displayedLosts!.length) {
      endIndex = displayedLosts!.length;
    }
    displayedLosts = displayedLosts!.sublist(startIndex, endIndex);
  }

  void handleCategoryChanged(String? category) {
    setState(() {
      selectedCategory = category; // Update the selected category
      if (category == 'All') {
        // If 'All' category is selected, reset displayedLosts to allLosts
        displayedLosts = allLosts;
        // Reset currentPage to 1
        currentPage = 1;
        // Adjust displayedLosts based on currentPage and itemsPerPage
        updateDisplayedLosts();
      } else {
        // If a specific category is selected, filter displayedLosts based on the category
        displayedLosts = filterLostsByCategory(category);
        // Reset currentPage to 1
        currentPage = 1;
        // Adjust displayedLosts based on currentPage and itemsPerPage
        updateDisplayedLosts();
      }
    });
  }

  void nextPage() {
    setState(() {
      final totalLosts = allLosts!.length;
      if ((currentPage * itemsPerPage) < totalLosts) {
        currentPage++;
        int startIndex = (currentPage - 1) * itemsPerPage;
        int endIndex = currentPage * itemsPerPage;
        // Adjust endIndex if it exceeds the total number of lost items
        endIndex = endIndex > totalLosts ? totalLosts : endIndex;
        displayedLosts = allLosts!.sublist(startIndex, endIndex);
      }
    });
  }

  void previousPage() {
    setState(() {
      if (currentPage > 1) {
        currentPage--;
        int startIndex = (currentPage - 1) * itemsPerPage;
        int endIndex = currentPage * itemsPerPage;
        displayedLosts = allLosts!.sublist(startIndex, endIndex);
      }
    });
  }

  void searchLostItems(String query) {
    List<Datum> searchResult = allLosts!
        .where((lostItem) =>
            lostItem.itemName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      displayedLosts = searchResult;
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
        controller: _scrollController,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
              //show search bar component
              SrcBar(
                  searchController: searchController,
                  onSearch: searchLostItems),
            ],
          ),
          //underline
          Container(
            margin: const EdgeInsets.only(left: 25, top: 10, right: 25),
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
                  FilterCategories(
                    onCategoryChanged: handleCategoryChanged,
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Visibility(
              visible: isLoaded,
              child: GridView.builder(
                itemCount: displayedLosts?.length ?? 0,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) {
                  final latitude = double.parse(displayedLosts![index]
                      .latitude); // Convert latitude to double
                  final longitude =
                      double.parse(displayedLosts![index].longitude);
                  final lostId =
                      displayedLosts![index].lostId; // Retrieve lostId
                  return FutureBuilder<String>(
                    future:
                        RemoteService().getLocationName(latitude, longitude),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        // Show error message if an error occurs
                        return Text('Error: ${snapshot.error}');
                      } else {
                        // Display the item with its location name
                        final locationName = snapshot.data;
                        return InkWell(
                          onTap: () {
                            // Redirect to the LostItemPage passing the lostId
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LostItemPage(
                                  lostId:
                                      lostId, // Pass the lostId to the LostItemPage
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
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
                                  child: Image.network(
                                    displayedLosts![index].itemImage,
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
                                      return Text('Failed to load image');
                                    },
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  displayedLosts![index].itemName,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 1),
                                Row(
                                  children: [
                                    Icon(Icons.location_pin),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        locationName ?? 'Location not found',
                                        style: TextStyle(fontSize: 12),
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
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isExtend
          ? MyCompose(
              onTap: () {
                foundForm(context);
              },
            )
          : MyExtendedCompose(
              onTap: () {
                foundForm(context);
              },
            ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                previousPage();
              },
            ),
            Text(
              'Page $currentPage',
              style: TextStyle(fontSize: 16),
            ),
            if ((currentPage * itemsPerPage) <
                (allLosts?.length ??
                    0)) // Check if there are more items to display on the next page
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  nextPage();
                },
              )
            else
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: null,
              ), // Display the icon without an onPressed function
          ],
        ),
      ),
    );
  }
}
