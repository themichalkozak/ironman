import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';

abstract class EventLocalDataSource {

  Future<List<Event>> searchEventsByQuery(String query,int page);

  Future<List<EventDetail>> searchEventById(int id);

  Future<void> cacheEvents(List<Event> events,int page);

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
    return _filterByQuery(query,events);
  }

  @override
  Future<void> cacheEvents(List<Event> events, int page) async {
    eventBox.addAll(events);
  }


  Future<List<Event>> _filterByQuery(String query, List<Event> events) async {

    if(events == null){
      return [];
    }

    return events.where((Event event) =>
        event.eventTitle.contains(query) ||
        event.eventVenue.contains(query) ||
        event.eventCountryName.contains(query)
    ).toList();
  }

}