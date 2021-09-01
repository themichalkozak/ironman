import 'package:ironman/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/business/domain/models/event_detail.dart';

abstract class EventApiService {

  Future<List<Event>> searchEventsByQuery(String query, int page);

  Future<EventDetail> getEventById(int id);

  Future<List<Event>> searchUpcomingEventsByQuery(String query, int page, String dateTime);

  Future<List<Event>> searchPastEvents(String query, int page, String dateTime);

  Future<List<Event>> searchFilteredEvents(String query, int page, String filterAndOrder);
}