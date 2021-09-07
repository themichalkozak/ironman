import '../../../domain/models/event.dart';
import '../../../domain/models/event_detail.dart';

abstract class EventCacheDataSource {

  Future<List<Event>> searchEvents(String query, int page, String filterAndOrder);

  Future<EventDetail> searchEvent(int eventId);

  Future<void> insertEvent(Event event);

  Future<void> insertEvents(List<Event> events);

  Future<void> insertEventDetail(EventDetail eventDetail);

}