import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';

abstract class EventCacheDataSource {

  Future<List<Event>> searchEventsByQuery(String query, int page, String filterAndOrder);

  Future<EventDetail> searchEvent(EventDetail event);

  Future<List<Event>> searchEventsBeforeNow (String query, int page,String filterAndOrder);

  Future<List<Event>> searchEventsAfterNow(String query, int page,String filterAndOrder);

  Future<void> insertEvent(Event event);

  Future<void> insertEvents(List<Event> events);

}