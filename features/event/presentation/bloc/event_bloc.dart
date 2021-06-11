import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/domain/useCases/get_event_by_id.dart';
import 'package:ironman/features/event/domain/useCases/get_events.dart';
import 'package:ironman/features/event/domain/useCases/search_events_by_query.dart';
import 'package:meta/meta.dart';
import 'bloc.dart';

const String NO_ELEMENT_FAILURE_MESSAGE = 'Event not found';
const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String NO_INTERNET_FAILURE = 'No internet Connection';

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEvents getEvents;
  final SearchEventsByQuery searchEventsByQuery;
  final GetEventById getEventById;

  EventBloc(
      {@required this.getEvents,
      @required this.searchEventsByQuery,
      @required this.getEventById})
      : assert(getEventById != null),
        assert(getEvents != null),
        assert(searchEventsByQuery != null),
        super(Empty());

  EventState get initialState => Empty();

  @override
  Stream<EventState> mapEventToState(
    EventEvent event,
  ) async* {
    if (event is GetEventsEvent) {
      yield Loading();
      final failureOrEvents =
          await getEvents(GetEventsParams(eventTense: event.eventTense));
      yield failureOrEvents.fold(
          (failure) => Error(errorMessage: _mapFailureToMessage(failure)),
          (events) => Loaded(events: events));
    }

    if (event is SearchEventsByQueryEvent) {
      yield Loading();
      final failureOrEvents = await searchEventsByQuery(
          SearchEventsByQueryParams(
              query: event.query, eventTense: event.eventTense));
      yield failureOrEvents.fold(
          (failure) => Error(errorMessage: _mapFailureToMessage(failure)),
          (events) => Loaded(events: events));
    }

    if(event is GetEventByIdEvent) {
      yield Loading();
      final failOrEvent = await getEventById(
        GetEventByIdParams(id: event.id));
      yield failOrEvent.fold(
              (failure) => Error(errorMessage: _mapFailureToMessage(failure)),
              (event) => LoadedDetail(event: event));
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
      default:
        return 'Unexpected Error';
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
