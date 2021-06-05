import 'package:http/http.dart' as http;
import 'package:ironman/core/constants.dart';

import 'package:ironman/data/event/EventDetailModel.dart';
import 'package:ironman/data/event/EventModel.dart';
import 'package:ironman/domain/event/event_tense.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getEvents(EventTense eventTense);

  Future<List<EventModel>> searchEventsByQuery(
      String query, EventTense eventTense);

  Future<EventDetailModel> getEventById(int id);
}

class EventRemoteDataSourceImpl extends EventRemoteDataSource {
  final http.Client client;

  EventRemoteDataSourceImpl(this.client);

  @override
  Future<List<EventModel>> getEvents(EventTense eventTense) {
    client.get(BASE_URL + '/events',
        headers: {'Content-Type': 'application/json', 'apikey': API_KEY});
  }

  @override
  Future<EventDetailModel> getEventById(int id) {}

  @override
  Future<List<EventModel>> searchEventsByQuery(
      String query, EventTense eventTense) {
//
  }
}
