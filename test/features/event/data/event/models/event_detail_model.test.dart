
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/features/event/data/event/EventDetailModel.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';

import '../../../../../fixtures/fixture_reader.dart';

void main(){
  final testListEventSpec = [EventSpecificationModel(name: 'Triathlon',id: 357, parentId: null),EventSpecificationModel(name: 'Relay',id: 379, parentId: 357)];

  final testEventDetail = EventDetailModel(
      eventId: 149007,
      eventTitle: '1985 Ulster ETU Triathlon Team Relay European Championships',
      eventDate: "1985-06-08",
      eventFinishDate: "1985-06-08",
      eventVenue: 'Ulster',
      eventCountryName: 'Ireland',
      eventFlag: 'https://triathlon-images.imgix.net/images/icons/ie.png',
      eventSpecifications: testListEventSpec,
      eventWebSite:
      null,
      information: null);

  test('should be subclass of EventDetail',(){
    expect(testEventDetail,isA<EventDetail>());
  });

  test(' form Json when status is success return valid model',() async{
    // arrange
    final Map<String,dynamic> jsonMap =
    json.decode(fixture('/event/get_event_by_id.json'));
    // act
    final result = EventDetailModel.fromJson(jsonMap);
    // assert
    expect(result,testEventDetail);
  });


}