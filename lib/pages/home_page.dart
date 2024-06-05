import 'package:capstone_project/components/drawer.dart';
import 'package:capstone_project/components/near_items_card.dart';
import 'package:capstone_project/models/near_items_model.dart';
import 'package:capstone_project/models/place.dart';
import 'package:capstone_project/models/user_model.dart';
import 'package:capstone_project/pages/map.dart';
import 'package:capstone_project/pages/profile/profile.dart';
import 'package:capstone_project/pages/voucher_list.dart';
import 'package:capstone_project/models/user_provider.dart';
import 'package:capstone_project/services/remote_service.dart';
import 'package:capstone_project/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng? _userLocation;
  int? _userPoints;
  String? _userName;
  final RemoteService _remoteService = RemoteService();
  bool _isDisposed = false; // Track disposal state
  bool isLoading = true;
// Use SocketService instance

  // Method to fetch user's points
  void _fetchUserPoints() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final String userId = userProvider.uid ?? '';
      User? user = await _remoteService.getUserById(userId);
      setState(() {
        _userName = user?.name;
        _userPoints = user?.points;
      });
    } catch (e) {
      print('Error fetching user points: $e');
    }
  }

  // Method to get the user's current location
  void _getUserLocation() async {
    // Check if location permissions are granted
    var permissionStatus = await Permission.location.request();

    if (permissionStatus == PermissionStatus.granted) {
      // Location permissions granted, retrieve the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (!_isDisposed) {
        // Use the retrieved position
        setState(() {
          _userLocation = LatLng(position.latitude, position.longitude);
          // Fetch near items after getting user location
          if (_userLocation != null) {
            _getNearItems(_userLocation!.latitude, _userLocation!.longitude);
            isLoading = false;
          }
        });
      }
    } else {
      // Permissions not granted, handle accordingly
      print('Location permissions not granted');
    }
  }

  //navigate to profile page
  void goToProfile() {
    Navigator.pop(context);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  List<FoundNearItem> foundItems = [];
  List<LostNearItem> lostItems = [];
  void _getNearItems(double latitude, double longitude) async {
    try {
      final response = await _remoteService.getNearItems(latitude, longitude);

      if (response['data'] != null) {
        List<dynamic> data = response['data'];
        if (!_isDisposed) {
          setState(() {
            foundItems = data
                .where((item) => item != null && item['type'] == 'Found Item')
                .map((item) => FoundNearItem.fromJson(item))
                .toList();
            lostItems = data
                .where((item) => item != null && item['type'] == 'Lost Item')
                .map((item) => LostNearItem.fromJson(item))
                .toList();
          });
        }
      } else {
        print('API returned null or empty data');
      }
    } catch (error) {
      print('Error fetching near items: $error');
    }
  }

  Future<void> _refreshData() async {
    _getUserLocation();
    _fetchUserPoints();
  }

  @override
  void dispose() {
    _isDisposed = true; // Set the disposed flag to true
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _fetchUserPoints();
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
        onProfileTap: goToProfile,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          controller: ScrollController(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Welcome, ',
                        style: TextStyle(
                          fontFamily: 'josefinSans',
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
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to the desired page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const VoucherList()),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.redeem,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    'Points: ${_userPoints ?? 'N/A'}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(
                              0.5), // You can set the shadow color here
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(
                              0, 3), // changes the position of the shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: Column(
                        children: [
                          Text(
                            'Find near you!',
                            style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 100,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: _userLocation != null
                                ? Stack(
                                    children: [
                                      GoogleMap(
                                        mapType: MapType.normal,
                                        initialCameraPosition: CameraPosition(
                                          target: _userLocation!,
                                          zoom: 14,
                                        ),
                                        markers: {
                                          Marker(
                                            markerId:
                                                const MarkerId('userLocation'),
                                            position: _userLocation!,
                                          ),
                                        },
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => MapScreen(
                                                location: PlaceLocation(
                                                  latitude:
                                                      _userLocation!.latitude,
                                                  longitude:
                                                      _userLocation!.longitude,
                                                ),
                                                isSelecting: false,
                                                foundItems: foundItems,
                                                lostItems: lostItems,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ],
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Nearest activity',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(
                              0.5), // You can set the shadow color here
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: const Offset(
                              0, 3), // changes the position of the shadow
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 10),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : foundItems.isNotEmpty ||
                                          lostItems.isNotEmpty
                                      ? ListView.builder(
                                          itemCount: foundItems.length +
                                              lostItems.length,
                                          itemBuilder: (context, index) {
                                            List<dynamic> combinedItems = [
                                              ...foundItems,
                                              ...lostItems
                                            ];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: NearItemsCard(
                                                foundNearItems:
                                                    combinedItems[index]
                                                            is FoundNearItem
                                                        ? combinedItems[index]
                                                            as FoundNearItem
                                                        : null,
                                                lostNearItems:
                                                    combinedItems[index]
                                                            is LostNearItem
                                                        ? combinedItems[index]
                                                            as LostNearItem
                                                        : null,
                                              ),
                                            );
                                          },
                                        )
                                      : const Center(
                                          child: Text(
                                            'No Near Items',
                                            style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                              color: Color.fromRGBO(
                                                  43, 52, 153, 1),
                                            ),
                                          ),
                                        ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
