part of 'map_bloc.dart';

sealed class MapState {}

final class MapInitial extends MapState {}

class MapActionState extends MapState {}

class MapLoadedSuccessState extends MapState {
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  MapLoadedSuccessState({required this.markers, required this.polylines});
}

class MapOpenBottomSheetActionState extends MapActionState {}
