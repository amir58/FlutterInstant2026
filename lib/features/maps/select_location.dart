import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigations/features/maps/map_addresses_search.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() =>
      _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  late final GoogleMapController controller;

  Set<Marker> markers = {};

  final Set<Marker> maadiMarkers = {
    const Marker(
      markerId: MarkerId('maadi_grand_mall'),
      position: LatLng(29.9818, 31.2741),
      infoWindow: InfoWindow(
        title: 'Maadi Grand Mall',
        snippet: 'Popular shopping and commercial hub',
      ),
    ),
    const Marker(
      markerId: MarkerId('road_9_maadi'),
      position: LatLng(29.9592, 31.2619),
      infoWindow: InfoWindow(
        title: 'Road 9',
        snippet: 'Famous street for cafes, restaurants, and shopping',
      ),
    ),
    const Marker(
      markerId: MarkerId('maadi_digla'),
      position: LatLng(29.9625, 31.2736),
      infoWindow: InfoWindow(
        title: 'Degla Maadi',
        snippet: 'Residential and expat-friendly neighborhood',
      ),
    ),
    const Marker(
      markerId: MarkerId('maadi_corniche'),
      position: LatLng(29.9678, 31.2464),
      infoWindow: InfoWindow(
        title: 'Maadi Corniche',
        snippet: 'Scenic Nile view walkway and venues',
      ),
    ),
    const Marker(
      markerId: MarkerId('wadi_degla_protectorate'),
      position: LatLng(29.9452, 31.3325),
      infoWindow: InfoWindow(
        title: 'Wadi Degla Protectorate',
        snippet: 'Nature reserve perfect for hiking and cycling',
      ),
    ),
  };

  @override
  void initState() {
    super.initState();
    _determinePosition();
    getLivePositionStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select your location'),
        actions: [
          IconButton(
            onPressed: () async {
              final place = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MapAddressesSearchScreen(),
                ),
              );

              if (place == null) return;

              updateCurrentLocation(place);
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: GoogleMap(
        markers: markers,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        initialCameraPosition: CameraPosition(
          // target: LatLng(30.0444, 31.2357),
          // target: LatLng(30.053190, 31.201824),
          target: LatLng(30.057013, 31.201577),
          zoom: 15,
        ),
        onTap: onMapTapped,
        onMapCreated: (controller) {
          this.controller = controller;
        },
      ),
    );
  }

  void onMapTapped(LatLng argument) {
    final markerId = '${argument.latitude}${argument.longitude}';

    Marker marker = Marker(
      markerId: MarkerId(markerId),
      position: argument,
    );

    markers.clear();

    markers.add(marker);

    setState(() {});

    getMarkerData(argument);
  }

  Future<void> getMarkerData(LatLng argument) async {
    final Geocoding geocoding = Geocoding();

    List<Placemark> placemarks = await geocoding
        .placemarkFromCoordinates(
          argument.latitude,
          argument.longitude,
        );

    debugPrint(placemarks.length.toString());
    debugPrint(placemarks.first.country);
    debugPrint(placemarks.first.isoCountryCode);
    debugPrint(placemarks.first.name);
    debugPrint(placemarks.first.street);
    debugPrint(placemarks.first.postalCode);
    debugPrint(placemarks.first.locality);
    debugPrint(placemarks.first.subLocality);
    debugPrint(placemarks.first.administrativeArea);
    debugPrint(placemarks.first.subAdministrativeArea);
    debugPrint(placemarks.first.thoroughfare);
    debugPrint(placemarks.first.subThoroughfare);
  }

  void updateCurrentLocation(place) {
    final String address = place['formattedAddress'] as String? ?? '';

    final double lat =
        place['location']['latitude'] as double? ?? 0.0;

    final double lng =
        place['location']['longitude'] as double? ?? 0.0;

    debugPrint('$address\n$lat\n$lng');

    final latLng = LatLng(lat, lng);

    Marker marker = Marker(
      markerId: MarkerId(address),
      position: latLng,
    );

    markers.clear();

    markers.add(marker);

    setState(() {});

    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: 15),
      ),
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    final currentPosition = await Geolocator.getCurrentPosition();

    debugPrint(currentPosition.toString());
    debugPrint(currentPosition.accuracy.toString());
    debugPrint(currentPosition.isMocked.toString());

    return currentPosition;
  }

  void getLivePositionStream() {
    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(
          locationSettings: locationSettings,
        ).listen((Position? position) {
          print(
            position == null
                ? 'Unknown'
                : '${position.latitude.toString()}, ${position.longitude.toString()}',
          );
        });
  }
}
