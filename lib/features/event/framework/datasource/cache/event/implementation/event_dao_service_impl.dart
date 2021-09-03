import '../../eventDetail/mapper/cache_detail_event_mapper.dart';
import '../../../../../business/domain/models/event.dart';
import '../abstraction/event_dao_service.dart';
import '../hive/abstraction/event_hive.dart';
import '../mapper/cache_event_mapper.dart';
import '../model/event_cache_entity.dart';

class EventDaoServiceImpl extends EventDaoService {
  EventHive eventHive;
  EventCacheMapper cacheMapper;

  EventDaoServiceImpl(
      this.eventHive, this.cacheMapper);

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

}
