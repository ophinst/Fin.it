import 'package:capstone_project/components/drawer.dart';
import 'package:capstone_project/components/near_items_card.dart';
import 'package:capstone_project/models/near_items_model.dart';
import 'package:capstone_project/pages/profile.dart';
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
  final RemoteService _remoteService = RemoteService();

  // Method to get the user's current location
  void _getUserLocation() async {
    // Check if location permissions are granted
    var permissionStatus = await Permission.location.request();

    if (permissionStatus == PermissionStatus.granted) {
      // Location permissions granted, retrieve the current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Use the retrieved position
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        // Fetch near items after getting user location
        if (_userLocation != null) {
          _getNearItems(_userLocation!.latitude, _userLocation!.longitude);
        }
      });
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
      } else {
        print('API returned null or empty data');
      }
    } catch (error) {
      print('Error fetching near items: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    print(_userLocation);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String _name = userProvider.name ?? "Unknown";
    return Scaffold(
      backgroundColor: const Color.fromRGBO(244, 244, 244, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: Text(
              'LOST & FOUND',
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
      body: SingleChildScrollView(
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
                      _name,
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
                                const Text(
                                  '100',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Column(
                              children: [
                                Icon(
                                  Icons.arrow_circle_up,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Pay',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                )
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                Icon(
                                  Icons.add_box,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Top Up',
                                  style: TextStyle(
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
                              color: primaryColor, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            height: 100,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(15)),
                            child: _userLocation != null
                                ? GoogleMap(
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
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  )),
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
                            child: foundItems.isNotEmpty || lostItems.isNotEmpty
                                ? ListView.builder(
                                    itemCount:
                                        foundItems.length + lostItems.length,
                                    itemBuilder: (context, index) {
                                      List<dynamic> combinedItems = [
                                        ...foundItems,
                                        ...lostItems
                                      ];
                                      combinedItems.shuffle();
                                      return NearItemsCard(
                                        foundNearItems: combinedItems[index]
                                                is FoundNearItem
                                            ? combinedItems[index]
                                                as FoundNearItem
                                            : null,
                                        lostNearItems:
                                            combinedItems[index] is LostNearItem
                                                ? combinedItems[index]
                                                    as LostNearItem
                                                : null,
                                      );
                                    },
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
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
    );
  }
}
