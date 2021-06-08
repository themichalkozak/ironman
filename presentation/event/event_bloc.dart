import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ironman/domain/event/entity/event.dart';
import 'package:ironman/domain/event/event_tense.dart';
import 'package:meta/meta.dart';

part 'event_event.dart';
part 'event_state.dart';

const String NO_ELEMENT_FAILURE_MESSAGE = 'Event not found';
const String SERVER_FAILURE_MESSAGE = 'Server Failure';

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEvents getEvents;

  EventBloc({
    @required GetEvents getEvents,
  }): assert(getEvents != null),
  getEvents = getEvents;


  @override
  EventState get initialState => Empty();

  @override
  Stream<EventState> mapEventToState(
    EventEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
