part of 'event_bloc.dart';

@immutable
abstract class EventState extends Equatable {
  EventState([List props = const <dynamic>[]]): super(props);
}

class EventInitial extends EventState {}

class GetEvents extends EventState {
  final EventTense eventTense;

  GetEvents(this.eventTense): super([eventTense]);
}
