import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';
import 'package:ironman/features/event/domain/event_tense.dart';

@immutable
abstract class EventState extends Equatable {
  EventState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends EventState {}

class Loading extends EventState {}

class Loaded extends EventState {
  final List events;
  final bool isExhausted;
  final EventTense eventTense;

  Loaded({
    @required this.events,
    @required this.isExhausted,
    this.eventTense = EventTense.All
  }): super([events,isExhausted,eventTense]);

  Loaded copyWith({
    List events,
    bool isExhausted,
    EventTense eventTense,
  }) {
    if ((events == null || identical(events, this.events)) &&
        (isExhausted == null || identical(isExhausted, this.isExhausted)) &&
        (eventTense == null || identical(eventTense, this.eventTense))) {
      return this;
    }

    return new Loaded(
      events: events ?? this.events,
      isExhausted: isExhausted ?? this.isExhausted,
      eventTense: eventTense ?? this.eventTense,
    );
  }

  @override
  String toString() => 'Loaded | events.length: ${events.length} | isExhausted: $isExhausted | eventTense" $eventTense';
}

class LoadedDetail extends EventState {
  final EventDetail event;

  LoadedDetail({
    @required this.event,
  }): assert(event != null)
  ,super([event]);
}

class Error extends EventState {
  final String errorMessage;

  Error({
    @required this.errorMessage,
  }):super([errorMessage]);
}
