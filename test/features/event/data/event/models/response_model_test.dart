import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import '../../../../../../lib/core/domain/response.dart';
import '../../../../../../lib/core/data/response_model.dart';
import 'package:ironman/features/event/data/event/event_detailed_model.dart';

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
  
  final testResponseModel = ResponseModel(status: 'success',data: testEventDetail);

  test('should be a subclass of Response',() async {
    expect(testResponseModel,isA<Response>());
  });

  test('fromJson when status is success return valid model',() async{
    // arrange
    // get Json String
    final Map<String,dynamic> jsonMap = json.decode(fixture('/event/get_event_by_id_response.json'));

    // act
    final result = ResponseModel.fromJson(jsonMap);

    // assert
    expect(result,testResponseModel);
  });


}