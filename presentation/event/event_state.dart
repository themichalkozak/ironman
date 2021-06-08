part of 'event_bloc.dart';

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
  });
}

class Error extends EventState {
  final String errorMessage;

  Error({
    @required this.errorMessage,
  });
}
