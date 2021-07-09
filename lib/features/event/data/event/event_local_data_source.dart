import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';

abstract class EventLocalDataSource {
  Future<List<Event>> searchEventsByQuery(String query, int page);

  Future<List<EventDetail>> searchEventById(int id);

  Future<void> cacheEvents(List<Event> events, int page);
}

class HiveEventLocalDataSourceImpl extends EventLocalDataSource {
  final Box eventBox;

  HiveEventLocalDataSourceImpl(this.eventBox);

  @override
  Future<List<EventDetail>> searchEventById(int id) {
    // TODO: implement searchEventById
    throw UnimplementedError();
  }

  @override
  Future<List<Event>> searchEventsByQuery(String query, int page) async {
    final events = eventBox.values.toList().cast<Event>();
    List<Event> _filteredQuery = await _filterByQuery(query, events);
    return setupPagination(_filteredQuery, page, PER_PAGE);
  }

  @override
  Future<void> cacheEvents(List<Event> events, int page) async {
    events.toList().cast<Event>().forEach((Event event) async {
      _saveItem(event);
    });
  }

  Future<List<Event>> _filterByQuery(String query, List<Event> events) async {
    print(
        'local_data_source | _filterByQuery | query: $query list size: ${events.length}');

    if (events == null) {
      return [];
    }

    if(events.isEmpty){
      return [];
    }

    String _queryLowerCase = query.toLowerCase();

    List<Event> _filteredEvents = events
        .where((Event event) =>
            event.eventTitle.toLowerCase().contains(_queryLowerCase) ||
            event.eventVenue.toLowerCase().contains(_queryLowerCase) ||
            event.eventCountryName.toLowerCase().contains(_queryLowerCase))
        .toList();

    print(
        'local_data_source | _filterByQuery | query: $query filtered List size: ${events.length}');

    return _filteredEvents;
  }

  @visibleForTesting
  Future<List<Event>> setupPagination(
      List<Event> events, int page, int perPage) async {

    if (events == null) {
      return [];
    }

    if(events.isEmpty){
      return [];
    }

    int indexStart = (page - 1) * perPage;
    int indexEnd = page * perPage;

    if (indexEnd > events.length) {
      indexEnd = events.length;
    }

    if(indexStart > events.length){
      return [];
    }

    if (indexStart < 0) {
      throw CacheException(message: 'index out of range');
    }


    final list = events.getRange(indexStart, indexEnd).toList();

    list.forEach((element) {
      print('ID: ${element.eventId}');
    });

    print('event_local_data_source | _setUpPagination \n '
        ' params:'
        ' events.lengths: ${events.length}'
        ' pagEvents: ${list.length}'
        ' | indexStart:  $indexStart'
        ' | indexEnd: $indexEnd'
        ' | page: $page'
        ' | perPage: $perPage');

    return events.getRange(indexStart, indexEnd).toList();
  }

  Future<void> _saveItem(Event event) async {
    await eventBox.put(event.eventId, event);
  }
}
