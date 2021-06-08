
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/domain/event/event_tense.dart';

@immutable
abstract class EventEvent extends Equatable {
  EventEvent([List props = const <dynamic>[]]): super(props);
}

class EventInitial extends EventEvent {}

class GetEventsEvent extends EventEvent {
  final EventTense eventTense;

  GetEventsEvent({this.eventTense = EventTense.All}) : super([eventTense]);
}
