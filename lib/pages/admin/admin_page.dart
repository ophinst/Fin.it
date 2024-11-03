import 'package:capstone_project/components/drawer.dart';
import 'package:capstone_project/components/item_card.dart';
import 'package:capstone_project/components/user_card.dart';
import 'package:capstone_project/models/item_model.dart';
import 'package:capstone_project/models/recentact_model.dart';
import 'package:capstone_project/models/user_model.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:capstone_project/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final RemoteService _remoteService = RemoteService();
  bool _isDisposed = false; // Track disposal state
  bool isLoading = true;
  String? _userName;
  bool showUserList = false;
  bool showItemList = false;
  List<User> userList = []; // List to hold user data
  List<ItemModel> itemList = []; // List to hold item data
  int _userPage = 1;
  int _itemPage = 1;
  final ScrollController _scrollController = ScrollController();

  void _fetchUserName() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final String userId = userProvider.uid ?? '';
      User? user = await _remoteService.getUserById(userId);
      if (!_isDisposed) {
        setState(() {
          _userName = user?.name;
        });
      }
    } catch (e) {
      print('Error fetching user points: $e');
    }
  }

  Future<void> _refreshData() async {
    // Refresh logic here, such as re-fetching the user list
    // For example:
    try {
      final token = Provider.of<UserProvider>(context, listen: false).token;

      List<User> users = await _remoteService.getUsers(counter: _userPage);
      List<ItemModel> items = await _remoteService.getItems(counter: _itemPage, token: token ?? ''); // Fetch items

      if (!_isDisposed) {
        setState(() {
          userList = users;
          itemList = items; // Update the itemList
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<void> _loadMoreUsers(int page) async {
    try {
      List<User> newUsers = await _remoteService.getUsers(counter: page);
      if (!_isDisposed) {
        setState(() {
          userList = newUsers; // Replace the user list with new data
        });
      }
    } catch (e) {
      print('Error loading more users: $e');
    }
  }

  Future<void> _loadMoreItems(int page) async {
    try {
      final token = Provider.of<UserProvider>(context, listen: false).token;
      List<ItemModel> newItems = await _remoteService.getItems(counter: page, token: token ?? '');
      if (!_isDisposed) {
        setState(() {
          itemList = newItems; // Replace the item list with new data
        });
      }
    } catch (e) {
      print('Error loading more items: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true; // Set the disposed flag to true
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _refreshData(); // Fetch user and item list initially
  }

  void _showUserList() {
    setState(() {
      showUserList = true;
      showItemList = false;
    });
  }

  void _showItemList() {
    setState(() {
      showUserList = false;
      showItemList = true;
    });
  }

  void _nextUserPage() {
    setState(() {
      _userPage++;
      _loadMoreUsers(_userPage);
    });
  }

  void _previousUserPage() {
    if (_userPage > 1) {
      setState(() {
        _userPage--;
        _loadMoreUsers(_userPage);
      });
    }
  }

  void _nextItemPage() {
    setState(() {
      _itemPage++;
      _loadMoreItems(_itemPage);
    });
  }

  void _previousItemPage() {
    if (_itemPage > 1) {
      setState(() {
        _itemPage--;
        _loadMoreItems(_itemPage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              'FIN.IT : Lost and Found',
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'JosefinSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      drawer: MyDrawer(
        onProfileTap: null,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome, ',
                        style: TextStyle(
                          fontFamily: 'JosefinSans',
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        _userName ?? '',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          color: Color.fromRGBO(43, 52, 153, 1),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: _showUserList,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: showUserList ? Colors.white : Colors.black, 
                              backgroundColor: showUserList ? primaryColor : Colors.white,
                            ),
                            child: const Text('User List', style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _showItemList,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: showItemList ? Colors.white : Colors.black, 
                              backgroundColor: showItemList ? primaryColor : Colors.white,
                            ),
                            child: const Text('Item List', style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (showUserList) _buildUserList(),
                  if (showItemList) _buildItemList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: userList.length,
          itemBuilder: (context, index) {
            final user = userList[index];
            return UserCard(
              user: user,
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _previousUserPage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: primaryColor,
              ),
              child: const Text('Previous'),
            ),
            ElevatedButton(
              onPressed: _nextUserPage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: primaryColor,
              ),
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItemList() {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: itemList.length,
          itemBuilder: (context, index) {
            final item = itemList[index];
            return ItemCard(
              item: item,
            );
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: _previousItemPage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: primaryColor,
              ),
              child: const Text('Previous'),
            ),
            ElevatedButton(
              onPressed: _nextItemPage,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: primaryColor,
              ),
              child: const Text('Next'),
            ),
          ],
        ),
      ],
    );
  }
}
