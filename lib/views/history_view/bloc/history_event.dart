// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'history_bloc.dart';

sealed class HistoryEvent {}

class HistoryInitialEvent extends HistoryEvent {}

class HistoryIthItemDeletedPressedEvent extends HistoryEvent {
  final int id;

  HistoryIthItemDeletedPressedEvent({required this.id});
}

class HistoryIthCoordPinPressedEvent extends HistoryEvent {
  final MapBloc mapBloc;
  final GoogleMapController controller;
  final CoordsModel coords;

  HistoryIthCoordPinPressedEvent({
    required this.mapBloc,
    required this.controller,
    required this.coords,
  });
}

class HistoryGenerateCsvBtnClickedEvent extends HistoryEvent {}
