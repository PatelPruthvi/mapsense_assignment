import 'package:assignment_mapsense/views/history_view/ui/history_view.dart';
import 'package:assignment_mapsense/views/map_view/bloc/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Set<Marker> markers = {};
// Set<Polyline> polylines = {
//   const Polyline(
//     polylineId: PolylineId('id_1'),
//     points: [
//       LatLng(28.4595, 77.0266),
//       LatLng(28.4995, 77.0966),
//       // LatLng(30.4995, 80.0966),
//       // LatLng(25.4995, 82.0966),
//     ],
//     color: Colors.blue,
//   )
// };

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
  // getMarker() => markers;
}

class _MapViewState extends State<MapView> {
  late GoogleMapController googleMapController;
  final MapBloc mapBloc = MapBloc();
  //cor-ords of gurugram
  static const CameraPosition initialCameraPosition =
      CameraPosition(zoom: 8, target: LatLng(28.4595, 77.0266));
  @override
  void initState() {
    mapBloc.add(MapShowLinesClickedEvent());
    super.initState();
  }

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
              child: const Text('MapSense')),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_vert_outlined, color: Colors.white))
          ],
        ),
        body: BlocConsumer<MapBloc, MapState>(
          bloc: mapBloc,
          listenWhen: (previous, current) => current is MapActionState,
          listener: (context, state) {
            if (state is MapOpenBottomSheetActionState) {
              showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) => HistoryView(
                      controller: googleMapController, mapBloc: mapBloc));
            }
          },
          buildWhen: (previous, current) => current is! MapActionState,
          builder: (context, state) {
            switch (state.runtimeType) {
              case MapLoadedSuccessState:
                final successState = state as MapLoadedSuccessState;
                return GoogleMap(
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: initialCameraPosition,
                  onMapCreated: (controller) {
                    googleMapController = controller;
                  },
                  markers: successState.markers,
                  polylines: successState.polylines,
                );

              default:
                return Container();
            }
          },
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
                    mapBloc.add(MapHistoryCoordsBtnClickedEvent());
                  },
                  label: const Text("Location History"),
                  icon: const Icon(Icons.history_outlined)),
              FloatingActionButton.extended(
                  onPressed: () {
                    mapBloc.add(MapCurrLocationBtnClickedEvent(
                        controller: googleMapController));
                    // _determinePosition().then((value) async {
                    //   googleMapController.animateCamera(
                    //       CameraUpdate.newCameraPosition(CameraPosition(
                    //           zoom: 12,
                    //           target:
                    //               LatLng(value.latitude, value.longitude))));
                    //   markers.clear();
                    //   markers.add(Marker(
                    //       markerId: const MarkerId('currentLocation'),
                    //       position: LatLng(value.latitude, value.longitude)));
                    //   setState(() {});
                    //   final coords = CoordsModel(
                    //       lat: value.latitude, long: value.longitude);
                    //   await TableHelper.createItem(coords);
                    // }).onError((error, stackTrace) => null);
                  },
                  label: const Text("Current location"),
                  icon: const Icon(Icons.location_history)),
            ],
          ),
        ));
  }
}
