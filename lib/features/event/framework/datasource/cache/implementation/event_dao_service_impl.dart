import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/framework/datasource/cache/abstraction/event_dao_service.dart';
import 'package:ironman/features/event/framework/datasource/cache/hive/abstraction/event_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/mappers/cache_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/cache/model/event_cache_entity.dart';

class EventDaoServiceImpl extends EventDaoService {

  EventHive eventHive;
  EventCacheMapper cacheMapper;

  EventDaoServiceImpl(this.eventHive, this.cacheMapper);

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
  Future<List<Event>> returnOrderedQuery(String query, String filterAndOrder, int page) async {
    List<EventCacheEntity> list = await eventHive.returnOrderedQuery(query, filterAndOrder, page);
    return cacheMapper.entityListToDomainList(list);
  }

  @override
  Future<Event> searchEventById(int id) async {
    EventCacheEntity eventCacheEntity = await eventHive.searchEventById(id);
    return cacheMapper.mapToDomainModel(eventCacheEntity);
  }

  @override
  Future<List<Event>> searchEventsFilterByFutureDateDESC(String query, int page, {int pageSize = EVENT_PAGINATION_PAGE_SIZE, DateTime dateTime}) async {
    List<EventCacheEntity> list = await eventHive.searchEventsFilterByFutureDateASC(query, page);
    return cacheMapper.entityListToDomainList(list);
  }

  @override
  Future<List<Event>> searchEventsFilterByPastDateASC(String query, int page, {int pageSize = EVENT_PAGINATION_PAGE_SIZE, DateTime dateTime}) async {
    List<EventCacheEntity> list = await eventHive.searchEventsFilterByPastDateDESC(query, page);
    return cacheMapper.entityListToDomainList(list);
  }

  @override
  Future<List<Event>> searchEventsOrderByDateASC(String query, int page, {int pageSize = EVENT_PAGINATION_PAGE_SIZE}) async {
    List<EventCacheEntity> list = await eventHive.searchEventsOrderByDateASC(query, page);
    return cacheMapper.entityListToDomainList(list);
  }

  @override
  Future<List<Event>> searchEventsOrderByDateDESC(String query, int page, {int pageSize = EVENT_PAGINATION_PAGE_SIZE}) async {
    List<EventCacheEntity> list = await eventHive.searchEventsOrderByDateDESC(query, page);
    return cacheMapper.entityListToDomainList(list);
  }


}