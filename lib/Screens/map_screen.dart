import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  Location locationController = new Location();
  final Completer<GoogleMapController> mapController =
      Completer<GoogleMapController>();
  LatLng? cPosition = null;

  Future<void> cameraPosition(LatLng position) async {
    final GoogleMapController controller = await mapController.future;
    CameraPosition newCameraPos = CameraPosition(target: position, zoom: 13);
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(newCameraPos));
  }

  Future<void> getUserLocation() async {
    bool serviceEnable;
    PermissionStatus permissionGranted;
    serviceEnable = await locationController.serviceEnabled();
    if (serviceEnable) {
      serviceEnable = await locationController.requestService();
    } else {
      print("Not granted");

      return;
    }
    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Not granteaad");
        return;
      }
    }
    locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          cPosition =
              LatLng(currentLocation.latitude!, currentLocation.longitude!);
          cameraPosition(cPosition!);
          print(cPosition);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const LatLng myLocation = LatLng(24.860966, 66.990501);
    const LatLng newLocation = LatLng(24.860966, 66.990501);
    const LatLng sourceLocation = LatLng(24.8773, 67.1591);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          toolbarHeight: 70,
          title: Text(
            "Google Map",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        body:
            //  cPosition == null
            //     ? Center(
            //         child: CircularProgressIndicator(),
            //       )
            //     :
            GoogleMap(
          onMapCreated: ((GoogleMapController controller) =>
              mapController.complete(controller)),
          initialCameraPosition: CameraPosition(
            target: myLocation,
            zoom: 13,
          ),
          markers: {
            Marker(
                markerId: MarkerId("_myLocation"),
                icon: BitmapDescriptor.defaultMarker,
                position: cPosition!),
            Marker(
                markerId: MarkerId("_currentLocation"),
                icon: BitmapDescriptor.defaultMarker,
                position: newLocation),
            Marker(
                markerId: MarkerId("_sourceLocation"),
                icon: BitmapDescriptor.defaultMarker,
                position: sourceLocation),
          },
        ),
      ),
    );
  }
}
