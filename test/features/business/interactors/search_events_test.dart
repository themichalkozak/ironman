import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/platform/internet_cubit.dart';
import 'package:ironman/features/event/business/data/cache/abstraction/event_cache_data_source.dart';
import 'package:ironman/features/event/business/data/network/abstraction/event_network_data_source.dart';
import 'package:ironman/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/business/interactors/search_events_by_query.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/hive/abstraction/event_hive.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/test_generator.dart';

class MockInternetCubit extends Mock implements InternetCubit {}
class MockEventNetworkDataSource extends Mock implements EventNetworkDataSource {}
class MockEventCacheDataSource extends Mock implements EventCacheDataSource {}

void main(){
  MockInternetCubit mockInternetCubit;
  MockEventCacheDataSource mockEventCacheDataSource;
  MockEventNetworkDataSource mockEventNetworkDataSource;
  SearchEventsByQuery useCase;
  
  setUp((){
    mockInternetCubit = MockInternetCubit();
    mockEventNetworkDataSource = MockEventNetworkDataSource();
    mockEventCacheDataSource = MockEventCacheDataSource();
    useCase = SearchEventsByQuery(mockEventNetworkDataSource, mockEventCacheDataSource, mockInternetCubit);
  });

  // isCached ✔ >10 ✔
  test('call when data is cached and list is greater or equal 10',() async {
    List<Event> tEvents = getEvents(10);

    when(mockEventCacheDataSource.searchEvents(any, any, any))
    .thenAnswer((realInvocation) async => tEvents);

    final result = useCase.call(SearchEventsByQueryParams(page: 1,filterAndOrder: ORDER_BY_DATE_ASC,query: ''));

    expect(result,emitsInOrder([Right(tEvents)]));
  });

  // isCached ✔ >10 ❌ isConnected ✔
  test('call when data is cached and list is smaller than 10',() async {

    List<Event> tEvents = getEvents(6);
    List<Event> tUpdatedEvents = getEvents(10);

    when(mockInternetCubit.isConnected())
        .thenAnswer((realInvocation) async => true);

    int count = 0;
    when(mockEventCacheDataSource.searchEvents(any, any, any))
    .thenAnswer((realInvocation) async => [tEvents,tUpdatedEvents][count++]);

    when(mockEventNetworkDataSource.searchEvents(any, any, any))
    .thenAnswer((realInvocation) async => tUpdatedEvents);

    final result = useCase.call(SearchEventsByQueryParams(page: 1,filterAndOrder: ORDER_BY_DATE_ASC,query: ''));

    untilCalled(mockEventCacheDataSource.insertEvents(tUpdatedEvents));

    expect(result,emitsInOrder([Right(tUpdatedEvents)]));
  });

  // isCached ✔ >10 ❌ isConnected ❌

  test('call when data is cached and list size is less than 10 and no internet connection return list with size less than 10',() async{
    List<Event> tEvents = getEvents(6);

    when(mockInternetCubit.isConnected())
        .thenAnswer((realInvocation) async => false);

    when(mockEventCacheDataSource.searchEvents(any, any, any))
        .thenAnswer((realInvocation) async => tEvents);

    final result = useCase.call(SearchEventsByQueryParams(page: 1,filterAndOrder: ORDER_BY_DATE_ASC,query: ''));

    expect(result,emitsInOrder([Right(tEvents)]));
  });

  // isCached ✔ >10 ❌ isConnected ✔

  test('call when data is cached and list size is less than 10 and internet is connected return updated events',() async{
    List<Event> tEvents = getEvents(6);
    List<Event> tUpdatedEvents = getEvents(10);

    when(mockInternetCubit.isConnected())
        .thenAnswer((realInvocation) async => true);

    var count = 0;
    when(mockEventCacheDataSource.searchEvents(any, any, any))
        .thenAnswer((realInvocation) async => [tEvents,tUpdatedEvents][count++]);

    final result = useCase.call(SearchEventsByQueryParams(page: 1,filterAndOrder: ORDER_BY_DATE_ASC,query: ''));

    expect(result,emitsInOrder([Right(tUpdatedEvents)]));
  });

  // isCached ✔ >10 ❌ isConnected ✔ apiResult ❌

  test('call when data is cached and list size is less than 10 and internet is connected and api result is null return cached events',() async{
    List<Event> tEvents = getEvents(6);

    when(mockInternetCubit.isConnected())
        .thenAnswer((realInvocation) async => true);

    when(mockEventCacheDataSource.searchEvents(any, any, any))
        .thenAnswer((realInvocation) async => tEvents);

    when(mockEventNetworkDataSource.searchEvents('', 1, ORDER_BY_DATE_ASC))
    .thenAnswer((realInvocation) async => null);

    final result = useCase.call(SearchEventsByQueryParams(page: 1,filterAndOrder: ORDER_BY_DATE_ASC,query: ''));

    expect(result,emitsInOrder([Right(tEvents)]));
  });

  // isCached ❌ isConnected ✔


  test('call when data is not cached and internet is connected return events from network',() async{
    List<Event> tUpdatedEvents = getEvents(10);

    when(mockInternetCubit.isConnected())
        .thenAnswer((realInvocation) async => true);

    var count = 0;
    when(mockEventCacheDataSource.searchEvents(any, any, any))
        .thenAnswer((realInvocation) async => [null,tUpdatedEvents][count++]);

    when(mockEventNetworkDataSource.searchEvents('', 1, ORDER_BY_DATE_ASC))
        .thenAnswer((realInvocation) async => tUpdatedEvents);


    final result = useCase.call(SearchEventsByQueryParams(page: 1,filterAndOrder: ORDER_BY_DATE_ASC,query: ''));

    expect(result,emitsInOrder([Right(tUpdatedEvents)]));
  });

  // isCached ❌ isConnected

  test('call when data is not cached and no internet connection should return empty list',() async {

    when(mockEventCacheDataSource.searchEvents('', 1, ORDER_BY_DATE_ASC))
        .thenAnswer((realInvocation) async => null);

    when(mockInternetCubit.isConnected()).thenAnswer((realInvocation) async => false);

    final result = useCase.call(SearchEventsByQueryParams(page: 1,filterAndOrder: ORDER_BY_DATE_ASC,query: ''));
    expect(result,emitsInOrder([Right([])]));

  });

}