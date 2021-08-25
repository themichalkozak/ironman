import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:ironman/features/event/business/interactors/search_events_by_query.dart';
import '../../../business/domain/models/event.dart';
import 'package:ironman/features/event/framework/datasource/cache/hive/abstraction/event_hive.dart';
import 'package:meta/meta.dart';
import 'bloc.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final SearchEventsByQuery searchEventsByQuery;

  final int _initialPage = 1;

  String _query = '';
  int _page = 1;
  String _filterAndOrder = ORDER_BY_DATE_ASC;


  EventBloc({@required this.searchEventsByQuery,})
      : assert(searchEventsByQuery != null),
        super(Empty());

  EventState get initialState => Empty();

  bool updateFilterAndOrder(String newUpdateAndOrder) {
    print('event_bloc | newFilter: $newUpdateAndOrder');
    if (newUpdateAndOrder == null) {
      return false;
    }
    if (_filterAndOrder != newUpdateAndOrder) {
      _filterAndOrder = newUpdateAndOrder;
      // add(SearchNewQuery(
      //     query: _query, orderAndFilter: newUpdateAndOrder));
      return true;
    }
    return false;
  }

  int _getPageFromOffset(int offset) => offset ~/ PER_PAGE + 1;


  int getPage(List<Event> list) {
    if (list == null) {
      return 1;
    }
    return _getPageFromOffset(list.length);
  }

  bool updateSearchQuery(String newSearchQuery) {
    print('event_bloc | newSearchQuery: $newSearchQuery');
    if (newSearchQuery == null || newSearchQuery == _query) {
      return false;
    }
    _query = newSearchQuery;
    return true;
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
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

  void clearList(List<Event> prevList) {
    prevList = [];
  }

  void resetOrderAndFilter() {
    _filterAndOrder = EVENT_FILTER_QUERY;
  }

  void resetPage() {
    _page = _initialPage;
  }

  Stream<EventState> searchEvents(
      {int page, String query, String orderAndFilter, List<
          Event> prevList}) async* {
    print(
        'event_bloc | searchEvents | page: $_page | query: $_query | orderAndFilter: $orderAndFilter | prevList.size: ${prevList
            .length}');

    final failOrEvents = searchEventsByQuery(SearchEventsByQueryParams(
        query: _query,
        page: page,
        filterAndOrder: _filterAndOrder));

    // reset orderAndFilter !

    await for (var event in failOrEvents) {
      yield event.fold(
              (failure) =>
              Error(errorMessage: _mapFailureToMessage(failure)),
              (events) =>
              Loaded(
                  events: prevList + events,
                  isExhausted: events.length < PER_PAGE,
                  orderAndFilter: _filterAndOrder));
    }
  }

  @override
  Stream<EventState> mapEventToState(EventEvent event) async* {

    if (event is SearchNewQuery) {
      if (state is Loading) {
        return;
      }

      List<Event> prevList = [];

      resetOrderAndFilter();

      resetPage();

      if (updateSearchQuery(event.query)) {

        yield Loading();

        yield* searchEvents(
            page: _page,
            query: _query,
            orderAndFilter: _filterAndOrder,
            prevList: prevList);
      }
    }


    if (event is SearchNextPageResultEvent) {
      List<Event> previousList = [];

      if (state is Loaded) {
        previousList = (state as Loaded).events;
        if ((state as Loaded).isExhausted) {
          return;
        }

        _page = getPage(previousList);

        print('event_bloc | mapEventToSate | page: $_page');

        yield* searchEvents(page: _page,
            orderAndFilter: _filterAndOrder,
            prevList: previousList);
      }
    }

    if(event is UpdateOrderAndFilter){

      List<Event> prevList = [];

      resetPage();

      if(updateFilterAndOrder(event.orderAndFilter)){

        yield Loading();

        yield* searchEvents(page: _page,
            orderAndFilter: _filterAndOrder,
            prevList: prevList);
      }

    }


      // if (event is RefreshSearchEventsByQueryEvent) {
      //   if (state is Loading) {
      //     return;
      //   }
      //   if (state is Loaded) {
      //     if ((state as Loaded).events.isNotEmpty) {
      //       return;
      //     }
      //   }
      //
      //   print('event_bloc | RefreshSearchQuery | _query: $_query');
      //
      //   final failOrEvents = searchEventsByQuery(
      //       SearchEventsByQueryParams(query: _query, page: _initialPage));
      //
      //   await for (var event in failOrEvents) {
      //     yield event.fold(
      //         (failure) => Error(errorMessage: _mapFailureToMessage(failure)),
      //         (events) => Loaded(
      //             events: events,
      //             isExhausted: events.isEmpty,
      //             eventTense: _eventTense));
      //   }
      // }

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

