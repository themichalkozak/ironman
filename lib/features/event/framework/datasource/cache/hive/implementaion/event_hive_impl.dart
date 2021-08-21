import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/features/event/framework/datasource/cache/hive/abstraction/event_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/model/event_cache_entity.dart';

class EventHiveImpl extends EventHive {
  final Box eventBox;
  final Box singleEventsBox;

  EventHiveImpl(this.eventBox, this.singleEventsBox);

  @override
  Future<List<EventCacheEntity>> getAllEvents() async {
    return eventBox.values.toList().cast<EventCacheEntity>();
  }

  @override
  Future<void> insertEvent(EventCacheEntity event) async {
    eventBox.put(event.eventId, event);
  }

  @override
  Future<void> insertEvents(List<EventCacheEntity> events) async {
    events.forEach((element) {
      insertEvent(element);
    });
  }

  @override
  Future<List<EventCacheEntity>> returnOrderedQuery(
      String query, String filterAndOrder, int page) async {

    switch (filterAndOrder) {
      case ORDER_BY_DESC_FUTURE_DATE:
        {
          return searchEventsFilterByFutureDateDESC(query, page);
        }
      case ORDER_BY_ASC_PAST_DATE:
        {
          return searchEventsFilterByPastDateASC(query, page);
        }
      case ORDER_BY_DATE_ASC:
        {
          return searchEventsOrderByDateASC(query, page);
        }
      default:
        {
          return await searchEventsOrderByDateASC(query, page);
        }
    }
  }

  @override
  Future<List<EventCacheEntity>> searchEventsOrderByDateASC(
      String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE}) async {
    List<EventCacheEntity> events = await getAllEvents();
    events.sort((prev, next) => prev.eventDate.compareTo(next.eventDate));
    events = _filterByQuery(query, events);
    events = _setupPagination(events, page, pageSize);
    return events;
  }

  @override
  Future<List<EventCacheEntity>> searchEventsOrderByDateDESC(
      String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE}) async {
    List<EventCacheEntity> events = await getAllEvents();
    events.sort((prev, next) => prev.eventDate.compareTo(next.eventDate));
    return events.reversed;
  }

  @override
  Future<List<EventCacheEntity>> searchEventsFilterByFutureDateDESC(
      String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE, DateTime dateTime}) async {
    if (dateTime == null) {
      dateTime = DateTime.now();
    }
    List<EventCacheEntity> events = await getAllEvents();
    events = _filterByQuery(query, events);
    events = _filterByFutureDate(events,dateTime: dateTime);
    events = _orderByDateDESC(events);
    events = _setupPagination(events, page, pageSize);
    return events;
  }

  @override
  Future<List<EventCacheEntity>> searchEventsFilterByPastDateASC(
      String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE, DateTime dateTime}) async {
    if (dateTime == null) {
      dateTime = DateTime.now();
    }
    List<EventCacheEntity> events = await getAllEvents();
    events = _filterByQuery(query, events);
    events = _filterByPastDate(events,dateTime: dateTime);
    events = _orderByDateASC(events);
    events = _setupPagination(events, page, pageSize);
    return events;
  }

  @override
  Future<EventCacheEntity> searchEventById(int id) async {
    return singleEventsBox.get(id);
  }

  List<EventCacheEntity> _orderByDateASC(List<EventCacheEntity> events){
    events.sort((prev, next) => prev.eventDate.compareTo(next.eventDate));
    return events;
  }

  List<EventCacheEntity> _orderByDateDESC(List<EventCacheEntity> events){
    events.sort((prev, next) => prev.eventDate.compareTo(next.eventDate));
    return events.reversed;
  }

  List<EventCacheEntity> _filterByPastDate(List<EventCacheEntity> events,
      {DateTime dateTime}) {
    return events.where((element) {
      return element.eventDate.isBefore(dateTime);
    }).toList();
  }

  List<EventCacheEntity> _filterByFutureDate(List<EventCacheEntity> events,
      {DateTime dateTime}) {
    return events.where((element) {
      return element.eventDate.isAfter(dateTime);
    }).toList();
  }

  List<EventCacheEntity> _filterByQuery(
      String query, List<EventCacheEntity> events) {
    print(
        'event_hive_impl | _filterByQuery | query: $query | list size: ${events.length}');

    if (events == null) {
      return [];
    }

    if (events.isEmpty) {
      return [];
    }

    String _queryLowerCase = query.toLowerCase();

    List<EventCacheEntity> _filteredEvents = events
        .where((EventCacheEntity event) =>
            event.eventTitle.toLowerCase().contains(_queryLowerCase) ||
            event.eventVenue.toLowerCase().contains(_queryLowerCase) ||
            event.eventCountryName.toLowerCase().contains(_queryLowerCase))
        .toList();

    return _filteredEvents;
  }

  @visibleForTesting
  List<EventCacheEntity> _setupPagination(List<EventCacheEntity> events, int page, int perPage) {
    if (events == null) {
      return [];
    }

    if (events.isEmpty) {
      return [];
    }

    int indexStart = (page - 1) * perPage;
    int indexEnd = page * perPage;

    if (indexEnd > events.length) {
      indexEnd = events.length;
    }

    if (indexStart > events.length) {
      return [];
    }

    if (indexStart < 0) {
      throw CacheException(message: 'index out of range');
    }

    final list = events.getRange(indexStart, indexEnd).toList();


    print('event_local_data_source | _setUpPagination \n '
        ' params:'
        ' events.lengths: ${events.length}'
        ' events: ${list.length}'
        ' | indexStart:  $indexStart'
        ' | indexEnd: $indexEnd'
        ' | page: $page'
        ' | perPage: $perPage');

    return events.getRange(indexStart, indexEnd).toList();
  }
}
