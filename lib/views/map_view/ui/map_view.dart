import 'package:assignment_mapsense/Utils/utils.dart';
import 'package:assignment_mapsense/views/history_view/ui/history_view.dart';
import 'package:assignment_mapsense/views/map_view/bloc/map_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController googleMapController;
  final MapBloc mapBloc = MapBloc();
  //cor-ords of gurugram
  static const CameraPosition initialCameraPosition =
      CameraPosition(zoom: 12.5, target: LatLng(28.4595, 77.0266));
  @override
  void initState() {
    mapBloc.add(MapInitialEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.teal.shade900),
              child: const Text('MapSense')),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert_outlined, color: Colors.white),
              onSelected: (String val) {
                if (val.compareTo('Show Lines') == 0) {
                  mapBloc.add(MapShowLinesClickedEvent(
                      controller: googleMapController));
                } else if (val.compareTo('Show Co-ords') == 0) {
                  mapBloc.add(MapShowCoordsClickedEvent(
                      controller: googleMapController));
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Show Lines', 'Show Co-ords'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
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
            } else if (state is MapDisplayErrorFlushBarActionState) {
              Utils.flushBarErrorMsg(state.errorMsg, context);
            } else if (state is MapDisplayCoordsSaveSuccessActionState) {
              Utils.toastMessage(state.successMsg);
            }
          },
          buildWhen: (previous, current) => current is! MapActionState,
          builder: (context, state) {
            switch (state.runtimeType) {
              case MapLoadedSuccessState:
                final successState = state as MapLoadedSuccessState;
                return GoogleMap(
                  mapType: successState.mapType,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  initialCameraPosition: successState.markers.isNotEmpty
                      ? CameraPosition(
                          zoom: 12.5,
                          target: successState.markers.first.position)
                      : initialCameraPosition,
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
                  },
                  label: const Text("Current location"),
                  icon: const Icon(Icons.location_history)),
            ],
          ),
        ));
  }
}
