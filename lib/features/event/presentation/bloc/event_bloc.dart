import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import 'package:ironman/features/event/domain/useCases/search_events_by_query.dart';
import 'package:ironman/features/event/domain/useCases/search_local_events_by_query.dart';
import 'package:meta/meta.dart';
import 'bloc.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final SearchEventsByQuery searchEventsByQuery;
  final SearchLocalEventsByQuery searchLocalEventsByQuery;

  String _query = '';
  final int _initialPage = 1;
  EventTense _eventTense = EventTense.All;

  EventBloc(
      {@required this.searchEventsByQuery,
      @required this.searchLocalEventsByQuery})
      : assert(searchEventsByQuery != null),
        assert(searchLocalEventsByQuery != null),
        super(Empty());

  EventState get initialState => Empty();

  List<Event> _filterByEventTense(List<Event> events, EventTense eventTense) {

    final now = DateTime.now();

    switch (eventTense) {
      case EventTense.All:
        return events;

      case EventTense.Upcoming:
        return _getUpcomingEvents(now, events);

      case EventTense.Past:
        return _getPastEvents(now, events);
    }
    return [];
  }

  List<Event> _getUpcomingEvents(DateTime now, List<Event> events) {
    return events
        .where((Event event) =>
            _convertStringToDateTime(event.eventDate).isAfter(now))
        .toList();
  }

  List<Event> _getPastEvents(DateTime now, List<Event> events) {
    print('event_bloc | events.length: ${events.length} | now: $now ');
    List<Event> filtredEvents =
    events
        .where((Event event) =>
            _convertStringToDateTime(event.eventDate).isBefore(now))
        .toList();

    print('event_bloc | filtred events.length: ${filtredEvents.length}');
    return filtredEvents;
  }

  @override
  Stream<EventState> mapEventToState(
    EventEvent event,
  ) async* {
    if (event is SearchEventsByQueryEvent) {

        if (!updateSearchQuery(event.query)) return;

      yield Loading();

      final failOrEvents = searchEventsByQuery(
          SearchEventsByQueryParams(query: _query, page: _initialPage));

      _resetEventTenseFilter();

      await for (var event in failOrEvents) {
        yield event.fold(
            (failure) => Error(errorMessage: _mapFailureToMessage(failure)),
            (events) => Loaded(
                events: events,
                isExhausted: events.isEmpty,
                eventTense: _eventTense));
      }
    }

    if (event is SearchNextPageResultEvent) {
      if (state is Empty) return;

      if (state is Loaded) {
        final loadedState = state as Loaded;
        if (loadedState.isExhausted) return;

        final previousList = loadedState.events;

        print('event_bloc | mapEventToState | fetchNextPageResult | previous list lenght: ${previousList.length}');

        for(Event event in previousList){
          print(event.eventDate);
        }

        final failOrEvents = searchEventsByQuery(SearchEventsByQueryParams(
            query: _query, page: _getPageFromOffset(previousList.length)));

        List<Event> eventsToDisplay = [];
        await for (var event in failOrEvents) {
          yield event.fold(
              (failure) => Error(errorMessage: _mapFailureToMessage(failure)),
              (events) {
                eventsToDisplay = events;
                return Loaded(
                  events: _filterByEventTense(previousList + events,_eventTense),
                  isExhausted: events.length < PER_PAGE,
                  eventTense: _eventTense);
              });
        }

        print('event_bloc | fetchNextPageResult |');

        for(Event event in eventsToDisplay){
          print(event.eventDate);
        }
      }
    }

    if (event is RefreshSearchEventsByQueryEvent) {
      if (state is Loading) {
        return;
      }
      if (state is Loaded) {
        if ((state as Loaded).events.isNotEmpty) {
          return;
        }
      }

      print('event_bloc | RefreshSearchQuery | _query: $_query');

      final failOrEvents = searchEventsByQuery(
          SearchEventsByQueryParams(query: _query, page: _initialPage));

      await for (var event in failOrEvents) {
        yield event.fold(
            (failure) => Error(errorMessage: _mapFailureToMessage(failure)),
            (events) => Loaded(
                events: events,
                isExhausted: events.isEmpty,
                eventTense: _eventTense));
      }
    }

    if (event is FilterByEventTenseEvent) {
      final EventTense updatedEventTense = event.eventTense;

      if (!_updateEventTenseFilter(updatedEventTense)) {
        return;
      }

      if (state is Loaded) {

        yield Loading();

        final failOrEvents = searchLocalEventsByQuery(SearchEventsByQueryParams(
            query: _query, page: _initialPage));

        await for (var event in failOrEvents){
          yield event.fold(
                  (failure) => Error(errorMessage: _mapFailureToMessage(failure)),
                  (events) => Loaded(
                  events: _filterByEventTense(events, _eventTense),
                  isExhausted: events.isEmpty,
                  eventTense: _eventTense));
        }
      }
    }
  }


  bool updateSearchQuery(String newSearchQuery) {
    if (newSearchQuery == null || newSearchQuery == _query) {
      return false;
    }
    _query = newSearchQuery;
    return true;
  }

  DateTime _convertStringToDateTime(String stringToDate) {
    return DateTime.tryParse(stringToDate);
  }

  bool _updateEventTenseFilter(EventTense eventTense) {
    if (eventTense == null || eventTense == _eventTense) {
      print('Event Tense is equals as current or null');
      return false;
    }
    _eventTense = eventTense;
    return true;
  }

  void _resetEventTenseFilter() {
    _eventTense = EventTense.All;
  }


  int _getPageFromOffset(int offset) => offset ~/ PER_PAGE + 1;

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return failure.error ?? SERVER_FAILURE_MESSAGE;
      case NoElementFailure:
        return failure.error ?? NO_ELEMENT_FAILURE_MESSAGE;
      case NoInternetFailure:
        return NO_INTERNET_FAILURE;
      case NoInitialStateFailure:
        return NO_INITIAL_STATE_FAILURE;
      case TimeoutFailure:
        return failure.error ?? TIMEOUT_FAILURE_MESSAGE;
      case CacheFailure:
        return failure.error ?? CACHE_FAILURE;
      default:
        return 'Unexpected Error';
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  void onChange(Change<EventState> change) {
    print(change);
    super.onChange(change);
  }
}
