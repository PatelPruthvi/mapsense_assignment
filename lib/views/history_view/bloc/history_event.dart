part of 'history_bloc.dart';

sealed class HistoryEvent {}

class HistoryInitialEvent extends HistoryEvent {}

class HistoryIthItemDeletedPressedEvent extends HistoryEvent {
  final int id;

  HistoryIthItemDeletedPressedEvent({required this.id});
}
