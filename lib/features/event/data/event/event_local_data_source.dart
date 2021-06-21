import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';

abstract class EventLocalDataSource {

  Future<List<Event>> searchEventsByQuery(String query,int page);

  Future<List<EventDetail>> searchEventById(int id);

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
  Future<List<Event>> searchEventsByQuery(String query, int page) {
    // TODO: implement searchEventsByQuery
    throw UnimplementedError();
  }

}