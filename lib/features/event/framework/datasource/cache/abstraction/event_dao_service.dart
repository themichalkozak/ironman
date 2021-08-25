import 'package:ironman/features/event/business/domain/models/event_detail.dart';

import '../../../../business/domain/models/event.dart';
import 'package:ironman/features/event/framework/datasource/cache/hive/abstraction/event_hive.dart';

abstract class EventDaoService {

  Future<void> insertEvent(Event event);

  Future<void> insertEvents(List<Event> events);

  Future<EventDetail> searchEventById(int id);

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

  Future<void> insertEventDetail(EventDetail eventDetail);

}
