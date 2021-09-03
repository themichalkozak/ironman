

import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/business/domain/utils/date_util.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/mapper/cache_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/model/event_cache_entity.dart';

import '../../../../../../fixtures/test_generator.dart';

void main(){

  EventCacheMapper mapper;
  DateUtils dateUtils;

  setUp((){
    dateUtils = DateUtils();
    mapper = EventCacheMapper(dateUtils);
  });

  test('mapFromDomainModel when is correct value should return EventCacheEntity',() {

    Event tEvent = getEvents(1).first;
    EventCacheEntity tEventCacheEntity = getEventsCacheEntity(1).first;

    final result = mapper.mapFromDomainModel(tEvent);

    expect(result,tEventCacheEntity);

  });

  test('mapToDomainModel when is correct value should return Event',() {

    Event tEvent = getEvents(1).first;
    EventCacheEntity tEventCacheEntity = getEventsCacheEntity(1).first;

    final result = mapper.mapToDomainModel(tEventCacheEntity);

    expect(result,tEvent);

  });

  test('entityListToDomainList when is correct value should return List<EventCacheEntity>',() {

    List<Event> tEvents = getEvents(10);
    List<EventCacheEntity> tEventCacheEntities = getEventsCacheEntity(10);

    final result = mapper.entityListToDomainList(tEventCacheEntities);

    expect(result,tEvents);

  });

  test('domainListToEntityList when is correct value should return List<EventCacheEntity>',() {

    List<Event> tEvents = getEvents(10);
    List<EventCacheEntity> tEventCacheEntities = getEventsCacheEntity(10);

    final result = mapper.domainListToEntityList(tEvents);

    expect(result,tEventCacheEntities);

  });


}