part of 'event_bloc.dart';

@immutable
abstract class EventEvent extends Equatable {
  EventEvent([List props = const <dynamic>[]]): super(props);
}

class EventInitial extends EventEvent {}

class GetEvents extends EventEvent {
  final EventTense eventTense;

  GetEvents(this.eventTense) : super([eventTense]);
}
