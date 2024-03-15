import 'dart:async';

import 'package:assignment_mapsense/database/sql_helper.dart';
import 'package:assignment_mapsense/models/coords_model.dart';
import 'package:assignment_mapsense/views/map_view/bloc/map_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<HistoryInitialEvent>(historyInitialEvent);
    on<HistoryIthItemDeletedPressedEvent>(historyIthItemDeletedPressedEvent);
    on<HistoryIthCoordPinPressedEvent>(historyIthCoordPinPressedEvent);
  }

  FutureOr<void> historyInitialEvent(
      HistoryInitialEvent event, Emitter<HistoryState> emit) async {
    List<CoordsModel> coordsList = [];
    List<String> locations = [];

    var coordsMap = await TableHelper.getAllCoords();
    for (var element in coordsMap) {
      coordsList.add(CoordsModel.fromJson(element));
    }
    for (var element in coordsList) {
      locations.add(await getLocation(element.lat!, element.long!));
    }
    if (coordsList.isEmpty) {
      emit(HistoryListEmptyState());
    } else {
      emit(HistoryListLoadedSuccessState(
          coordsList: coordsList, locations: locations));
    }
  }

  FutureOr<void> historyIthItemDeletedPressedEvent(
      HistoryIthItemDeletedPressedEvent event,
      Emitter<HistoryState> emit) async {
    await TableHelper.deleteCoord(event.id);

    List<CoordsModel> coordsList = [];
    List<String> locations = [];

    var coordsMap = await TableHelper.getAllCoords();
    for (var element in coordsMap) {
      coordsList.add(CoordsModel.fromJson(element));
    }
    for (var element in coordsList) {
      locations.add(await getLocation(element.lat!, element.long!));
    }
    if (coordsList.isEmpty) {
      emit(HistoryListEmptyState());
    } else {
      emit(HistoryListLoadedSuccessState(
          coordsList: coordsList, locations: locations));
    }
  }

  FutureOr<void> historyIthCoordPinPressedEvent(
      HistoryIthCoordPinPressedEvent event, Emitter<HistoryState> emit) {
    emit(HistoryNavigateToPinActionState(
        coords: event.coords, controller: event.controller));
  }
}

Future<String> getLocation(double lat, double long) async {
  String location = "";
  await placemarkFromCoordinates(lat, long).then((value) {
    location = "${value[0].subLocality}, ${value[0].locality}";
    return location;
  }).onError((error, stackTrace) => "error");

  return location;
}
