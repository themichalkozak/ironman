import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';

abstract class EventApiService {

  Future<List<Event>> searchEventsByQuery(String query, int page);

  Future<EventDetail> getEventById(int id);

  Future<List<Event>> searchUpcomingEventsByQuery(String query, int page, String dateTime);
}