import 'package:ironman/features/event/business/data/cache/abstraction/event_cache_data_source.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/abstraciton/event_detail_service_dao.dart';
import '../../../domain/models/event.dart';
import '../../../domain/models/event_detail.dart';
import '../../../../framework/datasource/cache/event/abstraction/event_dao_service.dart';

class EventCacheDataSourceImpl extends EventCacheDataSource {

  EventDaoService eventDaoService;
  EventDetailServiceDao eventDetailServiceDao;

  EventCacheDataSourceImpl(this.eventDaoService,this.eventDetailServiceDao);

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
    return eventDetailServiceDao.searchEventById(eventId);
  }

  @override
  Future<List<Event>> searchEvents(String query, int page, String filterAndOrder) async {
    return eventDaoService.returnOrderedQuery(query, filterAndOrder, page);
  }

  @override
  Future<void> insertEventDetail(EventDetail eventDetail) async {
    return eventDetailServiceDao.insertEventDetail(eventDetail);
  }

}