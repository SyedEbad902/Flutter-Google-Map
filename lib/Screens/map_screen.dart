import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    const LatLng myLocation = LatLng(30.3753, 69.3451);
    return Scaffold(
      appBar: AppBar(
        title: Text("MAp"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: myLocation, zoom: 13),
      ),
    );
  }
}
