import 'dart:async';

import 'package:assignment_mapsense/database/sql_helper.dart';
import 'package:assignment_mapsense/exceptions/app_exceptions.dart';
import 'package:assignment_mapsense/models/coords_model.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(MapInitial()) {
    on<MapInitialEvent>(mapInitialEvent);
    on<MapCurrLocationBtnClickedEvent>(mapCurrLocationBtnClickedEvent);
    on<MapHistoryCoordsBtnClickedEvent>(mapHistoryCoordsBtnClickedEvent);
    on<MapIthLocationPressedEvent>(mapIthLocationPressedEvent);
    on<MapShowLinesClickedEvent>(mapShowLinesClickedEvent);
    on<MapShowCoordsClickedEvent>(mapShowCoordsClickedEvent);
  }

  FutureOr<void> mapInitialEvent(
      MapInitialEvent event, Emitter<MapState> emit) {
    emit(MapLoadedSuccessState(markers: {}, polylines: {}));
  }

  FutureOr<void> mapCurrLocationBtnClickedEvent(
      MapCurrLocationBtnClickedEvent event, Emitter<MapState> emit) async {
    Set<Marker> markers = {};
    Set<Polyline> polylines = {};
    await determinePosition().then((value) async {
      final coords = CoordsModel(lat: value.latitude, long: value.longitude);
      LatLng newLatLng = LatLng(value.latitude, value.longitude);
      markers.clear();
      markers.add(Marker(
          markerId: const MarkerId('currentLocation'),
          infoWindow: InfoWindow(
            title: 'Co-ords',
            snippet: 'lat: ${value.latitude} \nlong: ${value.longitude}',
          ),
          position: LatLng(value.latitude, value.longitude)));
      event.controller.animateCamera(CameraUpdate.newLatLng(newLatLng));
      emit(MapLoadedSuccessState(markers: markers, polylines: polylines));
      await TableHelper.createItem(coords);
      emit(MapShowToastActionState(successMsg: 'Co-ords Saved to db...'));
    }).onError((error, stackTrace) {
      emit(MapDisplayErrorFlushBarActionState(errorMsg: error.toString()));
    });
  }

  FutureOr<void> mapHistoryCoordsBtnClickedEvent(
      MapHistoryCoordsBtnClickedEvent event, Emitter<MapState> emit) {
    emit(MapOpenBottomSheetActionState());
  }

  FutureOr<void> mapIthLocationPressedEvent(
      MapIthLocationPressedEvent event, Emitter<MapState> emit) async {
    Set<Marker> markers = {};
    LatLng newLatLng = LatLng(event.coordsModel.lat!, event.coordsModel.long!);
    event.controller.animateCamera(CameraUpdate.newLatLngZoom(newLatLng, 12.5));
    markers.clear();

    markers.add(Marker(
      markerId: const MarkerId('currentLocation'),
      position: LatLng(event.coordsModel.lat!, event.coordsModel.long!),
      infoWindow: InfoWindow(
          snippet: event.coordsModel.markerSubTitle,
          title: event.coordsModel.markerTitle),
    ));

    emit(MapLoadedSuccessState(markers: markers, polylines: {}));
  }

  FutureOr<void> mapShowLinesClickedEvent(
      MapShowLinesClickedEvent event, Emitter<MapState> emit) async {
    Set<Marker> markers = {};
    Set<Polyline> polylines = {};
    List<CoordsModel> coordsList = [];
    await TableHelper.getAllCoords().then((coordsMap) {
      for (var element in coordsMap) {
        coordsList.add(CoordsModel.fromJson(element));
      }
      for (int i = 0; i < coordsList.length; i++) {
        final coordItem = coordsList[i];
        markers.add(Marker(
            markerId: MarkerId('$i'),
            infoWindow: InfoWindow(
                snippet: '${coordItem.markerSubTitle} \n $i',
                title: coordItem.markerTitle),
            position: LatLng(coordItem.lat!, coordItem.long!)));
      }
      polylines.add(Polyline(
          polylineId: const PolylineId('polyline_1'),
          points: [
            for (var element in coordsMap)
              LatLng(CoordsModel.fromJson(element).lat!,
                  CoordsModel.fromJson(element).long!)
          ],
          color: Colors.blue,
          width: 5));
      if (coordsList.isEmpty) {
        emit(MapShowToastActionState(
            successMsg: 'No lines are available in database...'));
      } else {
        event.controller.animateCamera(
            CameraUpdate.newLatLngZoom(markers.first.position, 10.2));
        emit(MapLoadedSuccessState(markers: markers, polylines: polylines));
      }
    }).onError((error, stackTrace) {
      emit(MapDisplayErrorFlushBarActionState(errorMsg: error.toString()));
    });
  }

  FutureOr<void> mapShowCoordsClickedEvent(
      MapShowCoordsClickedEvent event, Emitter<MapState> emit) async {
    Set<Marker> markers = {};

    List<CoordsModel> coordsList = [];
    emit(MapLoadedSuccessState(markers: {}, polylines: {}));
    await TableHelper.getAllCoords().then((value) {
      for (var element in value) {
        coordsList.add(CoordsModel.fromJson(element));
        for (int i = 0; i < coordsList.length; i++) {
          final coordItem = coordsList[i];

          markers.add(Marker(
              markerId: MarkerId('$i'),
              infoWindow: InfoWindow(
                  snippet: '${coordItem.markerSubTitle} \n $i',
                  title: coordItem.markerTitle),
              position: LatLng(coordItem.lat!, coordItem.long!)));
        }
        if (coordsList.isEmpty) {
          emit(MapShowToastActionState(
              successMsg: 'No co-ords are stored in database...'));
        } else {
          event.controller.animateCamera(
              CameraUpdate.newLatLngZoom(markers.first.position, 9.75));
          emit(MapLoadedSuccessState(markers: markers, polylines: {}));
        }
      }
    }).onError((error, stackTrace) {
      emit(MapDisplayErrorFlushBarActionState(errorMsg: error.toString()));
    });
  }
}

Future<Position> determinePosition() async {
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
      throw LocationPermissionDeniedException();
    }
  } else if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    throw LocationPermissionDeniedException();
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
