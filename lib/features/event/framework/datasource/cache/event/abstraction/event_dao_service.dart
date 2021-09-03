import '../../../../../business/domain/models/event.dart';
import '../hive/abstraction/event_hive.dart';

abstract class EventDaoService {

  Future<void> insertEvent(Event event);

  Future<void> insertEvents(List<Event> events);

  Future<List<Event>> getAllEvents();

  Future<List<Event>> returnOrderedQuery(
      String query, String filterAndOrder, int page);

}
