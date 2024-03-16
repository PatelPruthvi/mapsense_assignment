import 'dart:async';

import 'package:assignment_mapsense/database/sql_helper.dart';
import 'package:assignment_mapsense/models/coords_model.dart';
import 'package:assignment_mapsense/views/map_view/bloc/map_bloc.dart';
import 'package:bloc/bloc.dart';
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

    await TableHelper.getAllCoords().then((coordsMap) {
      for (var element in coordsMap) {
        coordsList.add(CoordsModel.fromJson(element));
      }

      if (coordsList.isEmpty) {
        emit(HistoryListEmptyState());
      } else {
        emit(HistoryListLoadedSuccessState(coordsList: coordsList));
      }
    }).onError((error, stackTrace) {
      emit(HistoryLoadingFailedState(errorMsg: error.toString()));
    });
  }

  FutureOr<void> historyIthItemDeletedPressedEvent(
      HistoryIthItemDeletedPressedEvent event,
      Emitter<HistoryState> emit) async {
    await TableHelper.deleteCoord(event.id).then((value) async {
      List<CoordsModel> coordsList = [];

      var coordsMap = await TableHelper.getAllCoords();
      for (var element in coordsMap) {
        coordsList.add(CoordsModel.fromJson(element));
      }

      if (coordsList.isEmpty) {
        emit(HistoryListEmptyState());
      } else {
        emit(HistoryListLoadedSuccessState(coordsList: coordsList));
      }
    }).onError((error, stackTrace) {
      emit(HistoryUnableToDeleteActionState(errorMsg: error.toString()));
    });
  }

  FutureOr<void> historyIthCoordPinPressedEvent(
      HistoryIthCoordPinPressedEvent event, Emitter<HistoryState> emit) {
    emit(HistoryNavigateToPinActionState(
        coords: event.coords, controller: event.controller));
  }
}
