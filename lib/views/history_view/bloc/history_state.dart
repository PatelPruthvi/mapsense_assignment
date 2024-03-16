part of 'history_bloc.dart';

sealed class HistoryState {}

final class HistoryInitial extends HistoryState {}

class HistoryActionState extends HistoryState {}

class HistoryLoadingFailedState extends HistoryState {
  final String errorMsg;

  HistoryLoadingFailedState({required this.errorMsg});
}

class HistoryListLoadedSuccessState extends HistoryState {
  final List<CoordsModel> coordsList;

  HistoryListLoadedSuccessState({required this.coordsList});
}

class HistoryListEmptyState extends HistoryState {}

class HistoryNavigateToPinActionState extends HistoryActionState {
  final CoordsModel coords;
  final GoogleMapController controller;

  HistoryNavigateToPinActionState(
      {required this.coords, required this.controller});
}

class HistoryUnableToDeleteActionState extends HistoryActionState {
  final String errorMsg;

  HistoryUnableToDeleteActionState({required this.errorMsg});
}

class HistoryDisplaySnackBarActionState extends HistoryActionState {
  final String msg;

  HistoryDisplaySnackBarActionState({required this.msg});
}
