import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:myapp/types/location_callback.dart';

//AIzaSyCv6Bez-GpNf48M1s-sNKlaKB68rtMN52g

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late GoogleMapController mapController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestLocationPermission();
  }
  LatLng _currentLocation = LatLng(37.7749, -122.4194); // Default location (San Francisco, CA)
  Future<void> requestLocationPermission() async {
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Handle denied permission (e.g., show a message to the user)
    } else if (permission == LocationPermission.deniedForever) {
      // Handle denied permission permanently (e.g., show a message to the user)
    }
  }
  Future<void> _getCurrentLocation() async {
    await requestLocationPermission();
    final Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
    // Move the camera to the new location
    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(_currentLocation, 20.0),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              GoogleMap(
                mapType: MapType.satellite,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(37.7749, -122.4194), // Initial map coordinates (San Francisco, CA)
                  zoom: 12.0, // Zoom level
                ),
                markers: {
                  Marker(
                    markerId: MarkerId('currentLocation'),
                    position: _currentLocation,
                    icon: BitmapDescriptor.defaultMarker,
                  ),
                },
              ),
              PlacePicker(
                apiKey: 'AIzaSyCv6Bez-GpNf48M1s-sNKlaKB68rtMN52g',
                onPlacePicked: (PickResult? result) {
                  LocationFunction locationFunction = ModalRoute.of(context)!.settings.arguments as LocationFunction;
                  //continue...
                  print(result?.geometry?.location ?? '');
                },
                initialPosition: _currentLocation,
                useCurrentLocation: true,
                resizeToAvoidBottomInset: false, // only works in page mode, less flickery, remove if wrong offsets
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getCurrentLocation,
        child: Icon(Icons.location_on),
      ),
    );
  }
}
