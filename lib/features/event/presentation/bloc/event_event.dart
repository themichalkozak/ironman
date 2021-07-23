import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/features/event/domain/event_tense.dart';

@immutable
abstract class EventEvent extends Equatable {
  EventEvent([List props = const <dynamic>[]]) : super(props);
}

class EventInitial extends EventEvent {}

class GetEventsEvent extends EventEvent {
  final EventTense eventTense;
  final int page;

  GetEventsEvent({this.eventTense = EventTense.All,this.page}) : super([eventTense,page]);
}

class SearchEventsByQueryEvent extends EventEvent {
  final String query;

  SearchEventsByQueryEvent({
    @required this.query,
  }): super([query]);

}

class SearchNextPageResultEvent extends EventEvent {
  SearchNextPageResultEvent();
}

class RefreshSearchEventsByQueryEvent extends EventEvent {
  RefreshSearchEventsByQueryEvent();
}
