import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';

@immutable
abstract class EventState extends Equatable {
  EventState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends EventState {}

class Loading extends EventState {}

class Loaded extends EventState {
  final List events;
  final bool isExhausted;

  Loaded({
    @required this.events,
    @required this.isExhausted
  }): super([events,isExhausted]);


  @override
  String toString() => 'Loaded | events.length: ${events.length} | isExhausted: $isExhausted';
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
