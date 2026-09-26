import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:navigations/features/maps/select_location.dart';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  GoogleMapController? _mapController;
  String? _mapStyle;

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    addIntialMarkers();
  }

  void addIntialMarkers() {
    markers.add(
      Marker(
        markerId: MarkerId('value'),
        position: LatLng(30.057013, 31.201577),
        infoWindow: InfoWindow(
          title: 'Location',
          snippet: "My Location",
        ),
      ),
    );
  }

  // Load the JSON file from assets
  Future<void> _loadMapStyle() async {
    final style = await rootBundle.loadString(
      'assets/map/map_style.json',
    );
    setState(() {
      _mapStyle = style;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    // Apply style if it was loaded before the map finished building
    if (_mapStyle != null) {
      _mapController!.setMapStyle(_mapStyle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                height: 200,
                margin: EdgeInsets.all(10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    trafficEnabled: false,
                    zoomGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    scrollGesturesEnabled: false,
                    rotateGesturesEnabled: false,
                    mapToolbarEnabled: false,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    initialCameraPosition: CameraPosition(
                      // target: LatLng(30.0444, 31.2357),
                      // target: LatLng(30.053190, 31.201824),
                      target: LatLng(30.057013, 31.201577),
                      zoom: 18,
                    ),
                    markers: markers,

                    onMapCreated: (controller) {
                      _onMapCreated(controller);
                      // Apply style here if it finishes loading after map creation
                      if (_mapStyle != null) {
                        controller.setMapStyle(_mapStyle);
                      }
                    },
                  ),
                ),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: Text('Login to view the location'),
                ),
              ),
            ],
          ),

          SizedBox(height: 50),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SelectLocationScreen(),
                ),
              );
            },
            child: Text('Select your location'),
          ),
        ],
      ),
    );
  }
}
