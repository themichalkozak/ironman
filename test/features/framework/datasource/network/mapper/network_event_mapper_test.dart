import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/framework/datasource/network/mappers/network_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/network/model/models.dart';

import '../../../../../fixtures/test_generator.dart';

void main(){

  EventNetworkMapper eventNetworkMapper;

  setUp((){
    eventNetworkMapper = EventNetworkMapper();
  });

  test('mapToDomainModel',(){
    Event tEvent = getEvents(1).first;
    EventDto tEventDto = getEventDto(1).first;

    final result = eventNetworkMapper.mapToDomainModel(tEventDto);

    expect(result,tEvent);
  });

  test('mapFromDomainModel',(){
    Event tEvent = getEvents(1).first;
    EventDto tEventDto = getEventDto(1).first;

    final result = eventNetworkMapper.mapFromDomainModel(tEvent);

    expect(result,tEventDto);
  });

  test('map Entity List To Domain List',(){
    List<Event> tEvents = getEvents(13);
    List<EventDto> tEventDtos = getEventDto(13);

    print(tEvents);
    print(tEventDtos);

    final result = eventNetworkMapper.mapEntityListToDomainList(tEventDtos);

    expect(result,tEvents);
  });

  test('map Domain List To Entity List',(){
    List<Event> tEvents = getEvents(13);
    List<EventDto> tEventDtos = getEventDto(13);

    print(tEvents);
    print(tEventDtos);

    final result = eventNetworkMapper.mapDomainListToEntityList(tEvents);

    expect(result,tEventDtos);
  });


}