import 'package:ironman/data/event/EventDetailModel.dart';
import 'package:ironman/data/event/EventModel.dart';
import 'package:ironman/domain/event/event_tense.dart';

abstract class EventRemoteDataSource {

  Future<List<EventModel>> getEvents(EventTense eventTense);

  Future<List<EventModel>> searchEventsByQuery(String query, EventTense eventTense);

  Future<EventDetailModel> getEventById(int id);
}