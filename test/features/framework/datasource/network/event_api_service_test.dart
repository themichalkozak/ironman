
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/hive/abstraction/event_hive.dart';
import 'package:ironman/features/event/framework/datasource/network/abstraction/event_api_service.dart';
import 'package:ironman/features/event/framework/datasource/network/client/abstraction/event_http_client.dart';
import 'package:ironman/features/event/framework/datasource/network/implementation/event_api_service_impl.dart';
import 'package:ironman/features/event/framework/datasource/network/mappers/network_event_detail_mapper.dart';
import 'package:ironman/features/event/framework/datasource/network/mappers/network_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/network/model/event_detailed_dto.dart';
import 'package:ironman/features/event/framework/datasource/network/model/event_dto.dart';
import 'package:mockito/mockito.dart';

import '../../../../fixtures/test_generator.dart';

class MockEventHttpClient extends Mock implements EventHttpClient {}
class MockEventNetworkMapper extends Mock implements EventNetworkMapper {}
class MockDetailEventNetworkMapper extends Mock implements DetailEventNetworkMapper {}

void main(){

  MockEventHttpClient mockEventHttpClient;
  MockEventNetworkMapper mockEventNetworkMapper;
  MockDetailEventNetworkMapper mockDetailEventNetworkMapper;
  EventApiService eventApiService;

  setUp((){
    mockEventHttpClient = MockEventHttpClient();
    mockEventNetworkMapper = MockEventNetworkMapper();
    mockDetailEventNetworkMapper = MockDetailEventNetworkMapper();
    eventApiService = EventApiServiceImpl(mockEventHttpClient, mockEventNetworkMapper, mockDetailEventNetworkMapper);
  });


  // Future<EventDetail> getEventById(int id);
  test('get Event By Id',() async {

    final int id = 1;

    final EventDetailDto tEventDetailDto = getEventDetailDto(1).first;
    final EventDetail tEventDetail = getTestEventDetail();

    when(mockEventHttpClient.getEventById(id))
    .thenAnswer((realInvocation) async => tEventDetailDto);

    when(mockDetailEventNetworkMapper.mapToDomainModel(tEventDetailDto))
    .thenAnswer((realInvocation) => tEventDetail);

    final result = await eventApiService.getEventById(id);

    expect(result,tEventDetail);

  });


  // Future<List<Event>> searchEvents(String query, int page, String filterAndOrder);

  test('search Events',() async {
    List<Event> tEvents = getEvents(10);
    List<EventDto> tEventsDto = getEventDto(10);

    when(mockEventHttpClient.searchFilteredEvents(any,any,any))
        .thenAnswer((realInvocation) async => tEventsDto);

    when(mockEventNetworkMapper.mapEntityListToDomainList(tEventsDto))
        .thenAnswer((realInvocation) => tEvents);

    final result = await eventApiService.searchEvents('', 1, ORDER_BY_DATE_ASC);

    expect(result,tEvents);


  });


}

