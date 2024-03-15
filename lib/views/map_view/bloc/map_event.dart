part of 'map_bloc.dart';

sealed class MapEvent {}

class MapInitialEvent extends MapEvent {}

class MapCurrLocationBtnClickedEvent extends MapEvent {
  final GoogleMapController controller;

  MapCurrLocationBtnClickedEvent({required this.controller});
}

class MapHistoryCoordsBtnClickedEvent extends MapEvent {}

class MapIthLocationPressedEvent extends MapEvent {
  final CoordsModel coordsModel;
  final GoogleMapController controller;

  MapIthLocationPressedEvent(
      {required this.coordsModel, required this.controller});
}

class MapShowLinesClickedEvent extends MapEvent {
  final GoogleMapController controller;

  MapShowLinesClickedEvent({required this.controller});
}
