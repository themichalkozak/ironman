import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import '../../eventDetail/mapper/cache_detail_event_mapper.dart';
import '../../eventDetail/model/event_detail_cache_entity.dart';

import '../../../../../business/domain/models/event.dart';
import '../abstraction/event_dao_service.dart';
import '../hive/abstraction/event_hive.dart';
import '../mapper/cache_event_mapper.dart';
import '../model/event_cache_entity.dart';

class EventDaoServiceImpl extends EventDaoService {
  EventHive eventHive;
  EventCacheMapper cacheMapper;
  EventDetailCacheMapper eventDetailCacheMapper;

  EventDaoServiceImpl(
      this.eventHive, this.cacheMapper, this.eventDetailCacheMapper);

  @override
  Future<List<Event>> getAllEvents() async {
    List<EventCacheEntity> events = await eventHive.getAllEvents();
    return cacheMapper.entityListToDomainList(events);
  }

  @override
  Future<void> insertEvent(Event event) async {
    return eventHive.insertEvent(cacheMapper.mapFromDomainModel(event));
  }

  @override
  Future<void> insertEvents(List<Event> events) async =>
      eventHive.insertEvents(cacheMapper.domainListToEntityList(events));

  @override
  Future<List<Event>> returnOrderedQuery(
      String query, String filterAndOrder, int page) async {
    List<EventCacheEntity> list =
        await eventHive.returnOrderedQuery(query, filterAndOrder, page);
    return cacheMapper.entityListToDomainList(list);
  }

  @override
  Future<List<Event>> searchEventsFilterByFutureDateDESC(String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE, DateTime dateTime}) async {
    List<EventCacheEntity> list =
        await eventHive.searchEventsFilterByFutureDateASC(query, page);
    return cacheMapper.entityListToDomainList(list);
  }

  @override
  Future<List<Event>> searchEventsFilterByPastDateASC(String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE, DateTime dateTime}) async {
    List<EventCacheEntity> list =
        await eventHive.searchEventsFilterByPastDateDESC(query, page);
    return cacheMapper.entityListToDomainList(list);
  }

  @override
  Future<List<Event>> searchEventsOrderByDateASC(String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE}) async {
    List<EventCacheEntity> list =
        await eventHive.searchEventsOrderByDateASC(query, page);
    return cacheMapper.entityListToDomainList(list);
  }

  @override
  Future<List<Event>> searchEventsOrderByDateDESC(String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE}) async {
    List<EventCacheEntity> list =
        await eventHive.searchEventsOrderByDateDESC(query, page);
    return cacheMapper.entityListToDomainList(list);
  }
}
