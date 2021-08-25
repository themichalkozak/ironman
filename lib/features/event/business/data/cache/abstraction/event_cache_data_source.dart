import '../../../domain/models/event.dart';
import '../../../domain/models/event_detail.dart';

abstract class EventCacheDataSource {

  Future<List<Event>> searchEventsByQuery(String query, int page, String filterAndOrder);

  Future<EventDetail> searchEvent(int eventId);

  Future<List<Event>> searchEventsBeforeNow (String query, int page,String filterAndOrder);

  Future<List<Event>> searchEventsAfterNow(String query, int page,String filterAndOrder);

  Future<void> insertEvent(Event event);

  Future<void> insertEvents(List<Event> events);

  Future<void> insertEventDetail(EventDetail eventDetail);

}