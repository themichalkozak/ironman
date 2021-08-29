import '../../../../../business/domain/models/event.dart';
import '../hive/abstraction/event_hive.dart';

abstract class EventDaoService {

  Future<void> insertEvent(Event event);

  Future<void> insertEvents(List<Event> events);

  Future<List<Event>> getAllEvents();

  Future<List<Event>> searchEventsOrderByDateASC(String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE});

  Future<List<Event>> searchEventsOrderByDateDESC(String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE});

  Future<List<Event>> searchEventsFilterByFutureDateDESC(String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE,DateTime dateTime});

  Future<List<Event>> searchEventsFilterByPastDateASC(String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE,DateTime dateTime});

  Future<List<Event>> returnOrderedQuery(
      String query, String filterAndOrder, int page);

}
