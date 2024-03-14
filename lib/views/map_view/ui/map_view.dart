import 'package:assignment_mapsense/database/sql_helper.dart';
import 'package:assignment_mapsense/models/coords_model.dart';
import 'package:assignment_mapsense/views/history_view/ui/history_view.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

Set<Marker> markers = {};

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
  getMarker() => markers;
}

class _MapViewState extends State<MapView> {
  late GoogleMapController googleMapController;
  // co-ords of gurgaon
  static const CameraPosition initialCameraPosition =
      CameraPosition(zoom: 12, target: LatLng(28.4595, 77.0266));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        // appBar: AppBar(
        //   title: Container(
        //       padding: const EdgeInsets.all(10),
        //       decoration: BoxDecoration(
        //           borderRadius: BorderRadius.circular(10),
        //           color: Colors.teal.shade900),
        //       child: const Row(
        //         mainAxisSize: MainAxisSize.min,
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Icon(Icons.map_outlined, color: Colors.white),
        //           SizedBox(width: 10),
        //           Text('MapSense'),
        //         ],
        //       )),
        // ),
        body: GoogleMap(
          myLocationButtonEnabled: false,
          zoomControlsEnabled: false,
          initialCameraPosition: initialCameraPosition,
          onMapCreated: (controller) {
            googleMapController = controller;
          },
          markers: markers,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * .02),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton.extended(
                  onPressed: () {
                    showModalBottomSheet(
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) => HistoryView(
                            controller: googleMapController,
                            markers: markers)).then((value) {
                      setState(() {});
                    });
                  },
                  label: const Text("Location History"),
                  icon: const Icon(Icons.history_outlined)),
              FloatingActionButton.extended(
                  onPressed: () {
                    _determinePosition().then((value) async {
                      googleMapController.animateCamera(
                          CameraUpdate.newCameraPosition(CameraPosition(
                              zoom: 12,
                              target:
                                  LatLng(value.latitude, value.longitude))));
                      markers.clear();
                      markers.add(Marker(
                          markerId: const MarkerId('currentLocation'),
                          position: LatLng(value.latitude, value.longitude)));
                      setState(() {});
                      final coords = CoordsModel(
                          lat: value.latitude, long: value.longitude);
                      await TableHelper.createItem(coords);
                    }).onError((error, stackTrace) => null);
                  },
                  label: const Text("Current location"),
                  icon: const Icon(Icons.location_history)),
            ],
          ),
        ));
  }
}

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
  } else if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
