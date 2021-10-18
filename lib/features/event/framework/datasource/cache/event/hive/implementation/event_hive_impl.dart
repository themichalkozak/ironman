import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/core/error/exceptions.dart';
import '../abstraction/event_hive.dart';
import '../../model/event_cache_entity.dart';

class EventHiveImpl extends EventHive {
  final Box eventBox;

  EventHiveImpl(this.eventBox);

  @override
  Future<List<EventCacheEntity>> getAllEvents() async {
    return eventBox.values.toList().cast<EventCacheEntity>();
  }

  @override
  Future<void> insertEvent(EventCacheEntity event) async {
    return eventBox.put(event.eventId, event);
  }

  @override
  Future<void> insertEvents(List<EventCacheEntity> events) async {
    if(events == null){
      return;
    }
    return events.forEach((element) {
      insertEvent(element);
    });
  }

  @override
  Future<List<EventCacheEntity>> returnOrderedQuery(
      String query, String filterAndOrder, int page) async {

    switch (filterAndOrder) {
      case ORDER_BY_ASC_FUTURE_DATE:
        {
          return searchEventsFilterByFutureDateASC(query, page);
        }
      case ORDER_BY_DESC_PAST_DATE:
        {
          return searchEventsFilterByPastDateDESC(query, page);
        }
      case ORDER_BY_DATE_ASC:
        {
          return searchEventsOrderByDateASC(query, page);
        }
      default:
        {
          return searchEventsOrderByDateASC(query, page);
        }
    }
  }

  @override
  Future<List<EventCacheEntity>> searchEventsOrderByDateASC(
      String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE}) async {

    List<EventCacheEntity> events = await getAllEvents();

    if(events == null){
      return null;
    }
    events = _orderByDateASC(events);
    events = _filterByQuery(query, events);
    events = setupPagination(events, page, pageSize);
    return events;
  }


  @override
  Future<List<EventCacheEntity>> searchEventsFilterByFutureDateASC(
      String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE, DateTime dateTime}) async {
    if (dateTime == null) {
      dateTime = DateTime.now();
    }
    List<EventCacheEntity> events = await getAllEvents();

    if(events == null){
      return null;
    }

    events = _filterByQuery(query, events);
    events = _filterByFutureDate(events,dateTime: dateTime);
    events = _orderByDateASC(events);
    events = setupPagination(events, page, pageSize);

    return events;
  }

  @override
  Future<List<EventCacheEntity>> searchEventsFilterByPastDateDESC(
      String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE, DateTime dateTime}) async {
    if (dateTime == null) {
      dateTime = DateTime.now();
    }
    List<EventCacheEntity> events = await getAllEvents();

    if(events == null){
      return null;
    }

    events = _filterByQuery(query, events);
    events = _filterByPastDate(events,dateTime: dateTime);
    events = _orderByDateDESC(events);
    events = setupPagination(events, page, pageSize);

    return events;
  }

  List<EventCacheEntity> _orderByDateASC(List<EventCacheEntity> events){
    events.sort((prev, next) => prev.eventDate.compareTo(next.eventDate));
    return events;
  }

  List<EventCacheEntity> _orderByDateDESC(List<EventCacheEntity> events){
    events.sort((prev, next) => prev.eventDate.compareTo(next.eventDate));
    return events.reversed.toList();
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
  List<EventCacheEntity> setupPagination(List<EventCacheEntity> events, int page, int perPage) {
    if (events == null) {
      return null;
    }

    if (events.isEmpty) {
      return null;
    }

    int indexStart = (page - 1) * perPage;
    int indexEnd = page * perPage;

    if (indexEnd > events.length) {
      indexEnd = events.length;
    }

    if (indexStart > events.length) {
      return null;
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
