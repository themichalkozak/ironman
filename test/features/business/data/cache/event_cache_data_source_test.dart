import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/features/event/business/data/cache/abstraction/event_cache_data_source.dart';
import 'package:ironman/features/event/business/data/cache/implementation/event_cache_data_source_impl.dart';
import 'package:ironman/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/abstraction/event_dao_service.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/hive/abstraction/event_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/abstraciton/event_detail_service_dao.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/test_generator.dart';

class MockEventDaoService extends Mock implements EventDaoService {}
class MockEventDetailServiceDao extends Mock implements EventDetailServiceDao {}

void main(){

  MockEventDaoService mockEventDaoService;
  MockEventDetailServiceDao mockEventDetailServiceDao;
  EventCacheDataSource eventCacheDataSource;

  setUp((){
    mockEventDaoService = MockEventDaoService();
    mockEventDetailServiceDao = MockEventDetailServiceDao();
    eventCacheDataSource = EventCacheDataSourceImpl(mockEventDaoService, mockEventDetailServiceDao);
  });

  // Future<List<Event>> searchEventsByQuery(String query, int page, String filterAndOrder);

  test('search events by query',() async {

    List<Event> events = getEvents(10);

    when(mockEventDaoService.returnOrderedQuery(any, any, any))
        .thenAnswer((realInvocation) async => events);

    final result = await eventCacheDataSource.searchEvents('', 1, ORDER_BY_DATE_ASC);

    expect(result,events);

  });

  // Future<EventDetail> searchEvent(int eventId);

  test('search event by id when element was found return Event Detail',() async {

    EventDetail tEventDetail = getTestEventDetail();

    when(mockEventDetailServiceDao.searchEventById(any))
        .thenAnswer((realInvocation) async => tEventDetail);

    final result = await eventCacheDataSource.searchEvent(1);

    expect(result,tEventDetail);

  });

  test('search event by id when element wasn\'t found return null',() async {

    when(mockEventDetailServiceDao.searchEventById(any))
        .thenAnswer((realInvocation) async => null);

    final result = await eventCacheDataSource.searchEvent(1);

    expect(result,null);

  });

  // Future<List<Event>> searchEventsByQuery(String query, int page, String filterAndOrder);


  test('search Events By Query when element was found return Event Detail',() async {

    List<Event> tEvents = getEvents(10);

    when(mockEventDaoService.returnOrderedQuery(any,any,any))
        .thenAnswer((realInvocation) async => tEvents);

    final result = await eventCacheDataSource.searchEvents('',1,ORDER_BY_DATE_ASC);

    expect(result,tEvents);

  });

  // Future<void> insertEvent(Event event);

  test('insert event should invoke method insert event in eventDaoService',() async {

    Event tEvent = getEvents(1).first;

    await eventCacheDataSource.insertEvent(tEvent);

    verify(mockEventDaoService.insertEvent(tEvent));
  });

  //
  // Future<void> insertEvents(List<Event> events);

  test('insert events should invoke method insert events in eventDaoService',() async {

    List<Event> tEvents = getEvents(10);

    await eventCacheDataSource.insertEvents(tEvents);

    verify(mockEventDaoService.insertEvents(tEvents));
  });
  //
  // Future<void> insertEventDetail(EventDetail eventDetail);

  test('insert events should invoke method insert events in eventDaoService',() async {

    EventDetail tEventDetail = getTestEventDetail();

    await eventCacheDataSource.insertEventDetail(tEventDetail);

    verify(mockEventDetailServiceDao.insertEventDetail(tEventDetail));
  });



}