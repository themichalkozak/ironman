import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import 'package:ironman/features/event/domain/useCases/search_events_by_query.dart';
import 'package:meta/meta.dart';
import 'bloc.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final SearchEventsByQuery searchEventsByQuery;
  String _query = '';
  final int _initialPage = 1;

  EventBloc({@required this.searchEventsByQuery})
      : assert(searchEventsByQuery != null),
        super(Empty());

  EventState get initialState => Empty();

  @override
  Stream<EventState> mapEventToState(
    EventEvent event,
  ) async* {

    if (event is SearchEventsByQueryEvent) {

      if(state is Loaded){
        if(!updateSearchQuery(event.query)) return;
      }

      yield Loading();
      final failureOrEvents = await searchEventsByQuery(
          SearchEventsByQueryParams(
              query: event.query, eventTense: event.eventTense,page: _initialPage ));
      yield failureOrEvents
          .fold((failure) => Error(errorMessage: _mapFailureToMessage(failure)),
              (events) {
        return Loaded(events: events, isExhausted: events.isEmpty);
      });
    }
    if (event is SearchNextPageResultEvent) {

      if (state is Empty) return;

      if (state is Loaded) {
        final loadedState = state as Loaded;
        if (loadedState.isExhausted) return;

        final previousList = loadedState.events;

        final failureOrEvents = await searchEventsByQuery(SearchEventsByQueryParams(
            query: _query,eventTense: EventTense.All,page: _getPageFromOffset(previousList.length)
        ));

        yield failureOrEvents
            .fold((failure) => Error(errorMessage: _mapFailureToMessage(failure)),
                (events) {
              return Loaded(events:previousList + events , isExhausted: events.isEmpty);
            });

      }

    }
  }

  bool updateSearchQuery(String newSearchQuery){
    if(newSearchQuery == null || newSearchQuery == _query){
      return false;
    }
    _query = newSearchQuery;
    return true;
  }

  int _getPageFromOffset(int offset) => offset ~/ PER_PAGE + 1;

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
