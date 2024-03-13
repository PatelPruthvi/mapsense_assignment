import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController googleMapController;
  // co-ords of gurgaon
  static const CameraPosition initialCameraPosition =
      CameraPosition(zoom: 12, target: LatLng(28.4595, 77.0266));
  Set<Marker> markers = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.teal.shade900),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.map_outlined, color: Colors.white),
                  SizedBox(width: 10),
                  Text('MapSense'),
                ],
              )),
        ),
        body: GoogleMap(
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
                        builder: (context) => DraggableScrollableSheet(
                            initialChildSize: 0.35,
                            minChildSize: 0.15,
                            maxChildSize: 0.62,
                            builder: (_, scrollController) => Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Saved Co-ordinates",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily:
                                                  GoogleFonts.varelaRound()
                                                      .fontFamily,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
                                        ),
                                        Expanded(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            controller: scrollController,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            itemCount: 10,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 15),
                                                child: InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        border: Border.all(
                                                            color: Colors
                                                                .teal.shade900),
                                                        boxShadow: List.filled(
                                                            1,
                                                            const BoxShadow(
                                                                blurRadius: 2,
                                                                offset: Offset(
                                                                    .5, 2))),
                                                        color: Colors
                                                            .grey.shade200),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      15.0),
                                                          child: Text(
                                                            "${index + 1}",
                                                            style: TextStyle(
                                                                fontSize: 22,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontFamily: GoogleFonts
                                                                        .varelaRound()
                                                                    .fontFamily),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                  "Manjalpur, Vadodara",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontFamily:
                                                                          GoogleFonts.varelaRound()
                                                                              .fontFamily)),
                                                              const Text(
                                                                  "Lat: 34.32424"),
                                                              const Text(
                                                                  "Long: 77.874532"),
                                                            ],
                                                          ),
                                                        ),
                                                        IconButton(
                                                            onPressed: () {},
                                                            icon: const Icon(
                                                                Icons
                                                                    .delete_outline_outlined,
                                                                color:
                                                                    Colors.red))
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )));
                  },
                  label: const Text("Location History"),
                  icon: const Icon(Icons.history_outlined)),
              FloatingActionButton.extended(
                  onPressed: () {
                    _determinePosition().then((value) {
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
