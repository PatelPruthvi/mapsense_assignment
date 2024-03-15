part of 'map_bloc.dart';

sealed class MapState {}

final class MapInitial extends MapState {}

class MapActionState extends MapState {}

class MapLoadedSuccessState extends MapState {
  final MapType mapType;
  final Set<Marker> markers;
  final Set<Polyline> polylines;

  MapLoadedSuccessState(
      {this.mapType = MapType.normal,
      required this.markers,
      required this.polylines});
  MapLoadedSuccessState copyWith(
    MapType? mapType,
    Set<Marker>? markers,
    Set<Polyline>? polylines,
  ) {
    return MapLoadedSuccessState(
        mapType: mapType ?? this.mapType,
        markers: markers ?? this.markers,
        polylines: polylines ?? this.polylines);
  }
}

class MapOpenBottomSheetActionState extends MapActionState {}
