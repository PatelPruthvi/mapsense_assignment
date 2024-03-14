part of 'history_bloc.dart';

sealed class HistoryState {}

final class HistoryInitial extends HistoryState {}

class HistoryActionState extends HistoryState {}

class HistoryListLoadedSuccessState extends HistoryState {
  final List<CoordsModel> coordsList;
  final List<String> locations;

  HistoryListLoadedSuccessState(
      {required this.coordsList, required this.locations});
}

class HistoryListEmptyState extends HistoryState {}

class HistoryNavigateToPinActionState extends HistoryActionState {
  final CoordsModel coords;
  final GoogleMapController controller;

  HistoryNavigateToPinActionState(
      {required this.coords, required this.controller});
}
