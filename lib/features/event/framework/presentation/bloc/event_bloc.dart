import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:ironman/features/event/business/interactors/search_events_by_query.dart';
import 'package:ironman/features/event/framework/presentation/bloc/bloc.dart';
import '../../../business/domain/models/event.dart';
import '../../datasource/cache/event/hive/abstraction/event_hive.dart';
import 'package:meta/meta.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final SearchEventsByQuery searchEventsByQuery;

  final int _initialPage = 1;

  String _query = '';
  int _page = 1;
  String _filterAndOrder = ORDER_BY_DATE_ASC;

  EventBloc({
    @required this.searchEventsByQuery,
  })  : assert(searchEventsByQuery != null),
        super(Initial());

  EventState get initialState => Initial();

  bool updateFilterAndOrder(String newUpdateAndOrder) {
    print('event_bloc | newFilter: $newUpdateAndOrder');
    if (newUpdateAndOrder == null) {
      return false;
    }
    if (_filterAndOrder != newUpdateAndOrder) {
      _filterAndOrder = newUpdateAndOrder;
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
    if (newSearchQuery == null || newSearchQuery == _query) {
      return false;
    }
    print('event_bloc | newSearchQuery: $newSearchQuery');
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
      {int page,
      String query,
      String orderAndFilter,
      List<Event> prevList}) async* {

    final failOrEvents = searchEventsByQuery(SearchEventsByQueryParams(
        query: _query, page: page, filterAndOrder: _filterAndOrder));

    if(prevList == null){
      print('event_bloc | search_events: $prevList}');
      return;
    }

    await for (var event in failOrEvents) {
      yield event.fold((failure) {
        if (failure is TimeoutFailure) {
          print('event_bloc | searchEvents | Timeout Failure');
          if (state is Loaded) {
            return (state as Loaded).copyWith(isTimeout: true);
          }
        }

        return Error(errorMessage: _mapFailureToMessage(failure));
      },
          (events) => Loaded(
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

      if(!updateSearchQuery(event.query) && state is Loaded){
        return;
      }

      List<Event> prevList = [];

      resetOrderAndFilter();

      resetPage();

        yield Loading();

        yield* searchEvents(
            page: _page,
            query: _query,
            orderAndFilter: _filterAndOrder,
            prevList: prevList);
    }

    if (event is SearchNextPageResultEvent) {
      List<Event> previousList = [];

      if (state is Loaded) {
        previousList = (state as Loaded).events;

        if(state is Loaded){
          final cState = state as Loaded;

          if(cState.isExhausted){
            return;
          }
        }

        _page = getPage(previousList);

        print('event_bloc | mapEventToSate | page: $_page');

        yield* searchEvents(
            page: _page,
            orderAndFilter: _filterAndOrder,
            prevList: previousList);
      }
    }

    if (event is UpdateOrderAndFilter) {
      List<Event> prevList = [];

      resetPage();

      if (updateFilterAndOrder(event.orderAndFilter)) {
        yield Loading();

        yield* searchEvents(
            page: _page, orderAndFilter: _filterAndOrder, prevList: prevList);
      }
    }

    if (event is RefreshSearchEventsByQueryEvent) {
      List<Event> previousList = [];

      if (state is Loaded) {

        final cState = state as Loaded;

        previousList = cState.events;

        if (cState.isExhausted) {
          return;
        }

        if(cState.isTimeout){
          yield cState.copyWith(isTimeout: false);
        }

        _page = getPage(previousList);

        yield* searchEvents(
            page: _page,
            query: _query,
            orderAndFilter: _filterAndOrder,
            prevList: previousList);

      }

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
