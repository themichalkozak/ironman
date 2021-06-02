import 'package:ironman/data/event/EventModel.dart';
import 'package:ironman/domain/event/event_tense.dart';

abstract class EventRemoteDataSource {

  Future<EventModel> getEvents(EventTense eventTense);

  Future<EventModel> searchEventsByQuery(String query, EventTense eventTense);

  Future<EventModel> getEventById(int id);
}