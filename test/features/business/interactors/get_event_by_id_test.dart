import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/platform/internet_cubit.dart';
import 'package:ironman/features/event/business/data/cache/abstraction/event_cache_data_source.dart';
import 'package:ironman/features/event/business/data/network/abstraction/event_network_data_source.dart';
import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import 'package:ironman/features/event/business/interactors/get_event_by_id.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/test_generator.dart';

class MockInternetCubit extends Mock implements InternetCubit {}
class MockEventCacheDataSource extends Mock implements EventCacheDataSource {}
class MockEventNetworkDataSource extends Mock implements EventNetworkDataSource {}

void main(){

  MockInternetCubit mockInternetCubit;
  MockEventCacheDataSource mockEventCacheDataSource;
  MockEventNetworkDataSource mockEventNetworkDataSource;
  GetEventById getEventById;

  setUp((){
    mockInternetCubit = MockInternetCubit();
    mockEventNetworkDataSource = MockEventNetworkDataSource();
    mockEventCacheDataSource = MockEventCacheDataSource();
    getEventById = GetEventById(mockEventNetworkDataSource, mockEventCacheDataSource, mockInternetCubit);
  });


  // isCached -> true return cache YES
test('call when cache was found return EventDetail',() async {

  EventDetail tEventDetail = getTestEventDetail();

  when(mockInternetCubit.isConnected())
      .thenAnswer((realInvocation) async => true);

  when(mockEventCacheDataSource.searchEvent(any))
  .thenAnswer((realInvocation) async => tEventDetail);

  final id = 1;

  final result = getEventById.call(GetEventByIdParams(id: id));

  expect(result,emitsInOrder([Right(tEventDetail)]));

});


  // isCached -> false isInternetConnection -> false return NoElementException FALSE FALSE

  test('call when cache wasn\'t found and is interent connection return EventDetail',(){
    EventDetail tEventDetail = getTestEventDetail();

    final int id = 1;

    when(mockInternetCubit.isConnected())
    .thenAnswer((realInvocation) async => true);

    int callCount = 0;
    when(mockEventCacheDataSource.searchEvent(id))
        .thenAnswer((realInvocation) async => [null,tEventDetail][callCount++]);

    final result = getEventById.call(GetEventByIdParams(id: id));

    expect(result,emitsInOrder([Right(tEventDetail)]));

  });
  // isCached -> false isInternetConnection -> true check 1) apiResult 2) verify insert 3) return Cache FALSE TRUE

  test('call when cache wasn\'t found and is not interet connection return NoElementFailure',(){

    int id = 1;

    when(mockInternetCubit.isConnected())
    .thenAnswer((realInvocation) async => false);

    when(mockEventCacheDataSource.searchEvent(id))
    .thenAnswer((realInvocation) async => null);

    final result = getEventById.call(GetEventByIdParams(id: id));

    expect(result,emitsInOrder([Left(NoElementFailure())]));

  });

}
