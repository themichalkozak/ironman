import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:ironman/features/event/domain/useCases/search_events_by_query.dart';
import 'package:meta/meta.dart';
import 'bloc.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final SearchEventsByQuery searchEventsByQuery;

  EventBloc({@required this.searchEventsByQuery})
      : assert(searchEventsByQuery != null),
        super(Empty());

  EventState get initialState => Empty();

  @override
  Stream<EventState> mapEventToState(
    EventEvent event,
  ) async* {
    if (event is GetEventsEvent) {
      yield Loading();
      final failureOrEvents = await searchEventsByQuery(
          SearchEventsByQueryParams(eventTense: event.eventTense, query: ''));
      yield failureOrEvents
          .fold((failure) => Error(errorMessage: _mapFailureToMessage(failure)),
              (events) {
        return Loaded(events: events, isExhausted: events.length < PER_PAGE);
      });
    }

    if (event is SearchEventsByQueryEvent) {
      yield Loading();
      print('Event query: ${event.query}');
      final failureOrEvents = await searchEventsByQuery(
          SearchEventsByQueryParams(
              query: event.query, eventTense: event.eventTense));
      yield failureOrEvents
          .fold((failure) => Error(errorMessage: _mapFailureToMessage(failure)),
              (events) {
        return Loaded(events: events, isExhausted: events.length < PER_PAGE);
      });
    }
    if (event is SearchNextPageResultEvent) {
      yield Loading();
      final failureOrEvents = await searchEventsByQuery.fetchNextPageResult();
      yield failureOrEvents
          .fold((failure) => Error(errorMessage: _mapFailureToMessage(failure)),
              (events) {
        return Loaded(events: events, isExhausted: events.length < PER_PAGE);
      });
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
      case NoInitialStateFailure:
        return NO_INITIAL_STATE_FAILURE;
      default:
        return 'Unexpected Error';
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
