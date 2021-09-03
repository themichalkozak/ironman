import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/features/event/business/data/network/abstraction/event_network_data_source.dart';
import 'package:ironman/features/event/business/data/network/implementation/event_network_data_source_impl.dart';
import 'package:ironman/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/hive/abstraction/event_hive.dart';
import 'package:ironman/features/event/framework/datasource/network/abstraction/event_api_service.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/test_generator.dart';

class MockEventApiService extends Mock implements EventApiService {}

void main(){

  MockEventApiService mockEventApiService;
  EventNetworkDataSource eventNetworkDataSource;

  setUp((){
    mockEventApiService = MockEventApiService();
    eventNetworkDataSource = EventNetworkDataSourceImpl(mockEventApiService);
  });


  test('search Events',() async {

    List<Event> tEvents = getEvents(10);

    when(mockEventApiService.searchEvents(any, any, any))
    .thenAnswer((realInvocation) async => tEvents);

    final result = await  eventNetworkDataSource.searchEvents('', 1, ORDER_BY_DATE_ASC);

    expect(result,tEvents);
  });

}

