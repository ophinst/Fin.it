import 'package:capstone_project/models/near_items_model.dart';
import 'package:capstone_project/pages/found_item.dart';
import 'package:capstone_project/pages/lost_item.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import 'package:capstone_project/models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.location = const PlaceLocation(
      latitude: 37.422,
      longitude: -122.084,
      locationDetail: '',
    ),
    this.isSelecting = true,
    this.foundItems,
    this.lostItems,
  });

  final PlaceLocation location;
  final bool isSelecting;
  final List<FoundNearItem>? foundItems;
  final List<LostNearItem>? lostItems;

  @override
  State<StatefulWidget> createState() {
    return _MapScreenState();
  }
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;
  GoogleMapController? _mapController;
  final Location _location = Location();

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _updateMarkers();
    if (widget.isSelecting) {
      _setInitialLocation();
    }
  }

  Future<void> _setInitialLocation() async {
    try {
      final locationData = await _location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        setState(() {
          _pickedLocation = LatLng(locationData.latitude!, locationData.longitude!);
          _updateMarkers();
        });
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  void _updateMarkers() {
    _markers.clear();
    List<Marker> markers = [];

    // Markers for user's current location
    if (_pickedLocation != null && !widget.isSelecting) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: _pickedLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueRed,
          ),
        ),
      );
    }

    // Markers for found items
    if (widget.foundItems != null && !widget.isSelecting) {
      for (var foundItem in widget.foundItems!) {
        markers.add(
          Marker(
            markerId: MarkerId(foundItem.foundId),
            position: LatLng(foundItem.latitude, foundItem.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoundItemPage(
                    foundItem: foundItem.toGetFoundModel(),
                    foundId: foundItem.foundId,
                  ),
                ),
              );
            },
          ),
        );
      }
    }

    // Markers for lost items
    if (widget.lostItems != null && !widget.isSelecting) {
      for (var lostItem in widget.lostItems!) {
        markers.add(
          Marker(
            markerId: MarkerId(lostItem.lostId),
            position: LatLng(lostItem.latitude, lostItem.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
            infoWindow: InfoWindow(
              title: lostItem.lostId,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LostItemPage(
                    lostId: lostItem.lostId,
                  ),
                ),
              );
            },
          ),
        );
      }
    }

    _markers.addAll(markers);

    setState(() {});
  }

  Future<void> _getCurrentLocation() async {
    try {
      final locationData = await _location.getLocation();
      if (locationData.latitude != null && locationData.longitude != null) {
        _mapController?.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(locationData.latitude!, locationData.longitude!),
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelecting ? 'Pick your location' : 'Your location'),
        actions: [
          if (widget.isSelecting)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
            ),
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          _mapController = controller;
          if (widget.isSelecting) {
            _getCurrentLocation();
          }
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: !widget.isSelecting
            ? null
            : (position) {
                setState(() {
                  _pickedLocation = position;
                  _updateMarkers();
                });
                _markers.add(
                  Marker(
                    markerId: const MarkerId('selected_location'),
                    position: position,
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed,
                    ),
                  ),
                );
              },
        initialCameraPosition: CameraPosition(
          target: _pickedLocation ?? LatLng(
            widget.location.latitude,
            widget.location.longitude,
          ),
          zoom: 16,
        ),
        markers: {
          if (_pickedLocation != null && widget.isSelecting)
            Marker(
              markerId: const MarkerId('selected_location'),
              position: _pickedLocation!,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
          if (!widget.isSelecting)
            Marker(
              markerId: const MarkerId('user_location'),
              position: LatLng(
                widget.location.latitude,
                widget.location.longitude,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueRed,
              ),
            ),
          ..._markers,
        },
      ),
    );
  }
}
