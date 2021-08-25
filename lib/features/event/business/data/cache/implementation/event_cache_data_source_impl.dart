import 'package:ironman/features/event/business/data/cache/abstraction/event_cache_data_source.dart';
import '../../../domain/models/event.dart';
import '../../../domain/models/event_detail.dart';
import 'package:ironman/features/event/framework/datasource/cache/abstraction/event_dao_service.dart';

class EventCacheDataSourceImpl extends EventCacheDataSource {

  EventDaoService eventDaoService;

  EventCacheDataSourceImpl(this.eventDaoService);

  @override
  Future<void> insertEvent(Event event) async {
    return eventDaoService.insertEvent(event);
  }

  @override
  Future<void> insertEvents(List<Event> events) async {
    return eventDaoService.insertEvents(events);
  }

  @override
  Future<EventDetail> searchEvent(int eventId) {
    return eventDaoService.searchEventById(eventId);
  }

  @override
  Future<List<Event>> searchEventsAfterNow(String query, int page, String filterAndOrder) async {
    return eventDaoService.returnOrderedQuery(query, filterAndOrder, page);
  }

  @override
  Future<List<Event>> searchEventsBeforeNow(String query, int page, String filterAndOrder) async {
    return eventDaoService.returnOrderedQuery(query, filterAndOrder, page);
  }

  @override
  Future<List<Event>> searchEventsByQuery(String query, int page, String filterAndOrder) async {
    return eventDaoService.returnOrderedQuery(query, filterAndOrder, page);
  }

  @override
  Future<void> insertEventDetail(EventDetail eventDetail) async {
    return eventDaoService.insertEventDetail(eventDetail);
  }

}