
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/abstraction/event_dao_service.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/hive/abstraction/event_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/implementation/event_dao_service_impl.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/mapper/cache_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/model/event_cache_entity.dart';
import 'package:mockito/mockito.dart';

import '../../../../../../fixtures/test_generator.dart';

class MockEventHive extends Mock implements EventHive {}
class MockEventCacheMapper extends Mock implements EventCacheMapper {}

main(){
  MockEventHive mockEventHive;
  MockEventCacheMapper mockEventCacheMapper;
  EventDaoService eventDaoService;

  setUp((){
    mockEventHive = MockEventHive();
    mockEventCacheMapper = MockEventCacheMapper();
    eventDaoService = EventDaoServiceImpl(mockEventHive, mockEventCacheMapper);
  });


  test('insert Event should invoke insert method in event Hive',(){

    Event tEvent = getEvents(1).first;
    EventCacheEntity tEventCacheEntity = getEventsCacheEntity(1).first;

    when(mockEventCacheMapper.mapFromDomainModel(tEvent))
    .thenReturn(tEventCacheEntity);

    eventDaoService.insertEvent(tEvent);
    verify(mockEventHive.insertEvent(tEventCacheEntity));
  });

  test('insert Events should invoke insert list method in event Hive',(){

    List<Event> tEvents = getEvents(10);
    List<EventCacheEntity> tEventCacheEntities = getEventsCacheEntity(10);

    when(mockEventCacheMapper.domainListToEntityList(tEvents))
        .thenReturn(tEventCacheEntities);

    eventDaoService.insertEvents(tEvents);
    verify(mockEventHive.insertEvents(tEventCacheEntities));
  });


  test('get All Events should return list of Events',() async {
    List<Event> tEvents = getEvents(10);
    List<EventCacheEntity> tEventCacheEntity = getEventsCacheEntity(10);

    when(mockEventHive.getAllEvents())
    .thenAnswer((realInvocation) async => tEventCacheEntity);

    when(mockEventCacheMapper.entityListToDomainList(tEventCacheEntity))
    .thenAnswer((realInvocation) => tEvents);

    final result = await eventDaoService.getAllEvents();

    expect(result,tEvents);

  });
  
  test('returnOrderedQuery when filterAndOrder is All should return list of events',() async {
    List<EventCacheEntity> tEventCacheEntity = getEventsCacheEntity(10);
    List<Event> tEvents = getEvents(10);

    when(mockEventHive.returnOrderedQuery(any, ORDER_BY_DATE_ASC,any))
        .thenAnswer((realInvocation) async => tEventCacheEntity);

    when(mockEventCacheMapper.entityListToDomainList(tEventCacheEntity))
        .thenAnswer((realInvocation) => tEvents);

    final result = await eventDaoService.returnOrderedQuery('',ORDER_BY_DATE_ASC, 1);

    expect(result,tEvents);

  });


}