import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/features/event/domain/entity/event.dart';

@immutable
abstract class EventState extends Equatable {
  EventState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends EventState {}

class Loading extends EventState {}

class Loaded extends EventState {
  final List<Event> events;

  Loaded({
    @required this.events,
  }):super([events]);
}

class Error extends EventState {
  final String errorMessage;

  Error({
    @required this.errorMessage,
  }):super([errorMessage]);
}
