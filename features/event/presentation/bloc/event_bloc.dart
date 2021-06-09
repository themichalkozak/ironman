import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/domain/useCases/get_events.dart';
import 'package:meta/meta.dart';
import 'bloc.dart';

const String NO_ELEMENT_FAILURE_MESSAGE = 'Event not found';
const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String NO_INTERNET_FAILURE = 'No internet Connection';

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEvents getEvents;

  EventBloc({@required this.getEvents}): assert(getEvents != null), super(Empty());

  EventState get initialState => Empty();

  @override
  Stream<EventState> mapEventToState(
    EventEvent event,
  ) async* {
    if (event is GetEventsEvent) {
      yield Loading();
      final failureOrEvents = await getEvents(Params(eventTense: event.eventTense));
      yield failureOrEvents.fold(
              (failure) => Error(errorMessage: _mapFailureToMessage(failure)),
              (events) => Loaded(events: events));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case NoElementFailure:
        return failure.error ?? NO_ELEMENT_FAILURE_MESSAGE;
      case NoInternetFailure:
        return NO_INTERNET_FAILURE;
      default: return 'Unexpected Error';
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }

}
