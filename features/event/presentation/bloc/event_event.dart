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

  GetEventsEvent({this.eventTense = EventTense.All}) : super([eventTense]);
}

class SearchEventsByQueryEvent extends EventEvent {
  final String query;
  final EventTense eventTense;

  SearchEventsByQueryEvent({
    @required this.query,
    this.eventTense = EventTense.All,
  }): super([query,eventTense]);

}
