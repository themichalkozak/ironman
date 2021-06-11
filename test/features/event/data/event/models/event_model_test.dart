import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/features/event/data/event/EventModel.dart';
import 'package:ironman/features/event/domain/entity/event.dart';

import '../../../../../fixtures/fixture_reader.dart';


void main() {

  final tEventModel = EventModel(
    eventId: 122987,
    eventCountryName: 'Poland',
    eventVenue: "",
    eventFinishDate: '1992-01-01',
    eventDate: '1992-01-01',
    eventTitle: "1992 POL Duathlon National Championships",
    eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png",
  );

  test('should be a subclass of Event',() async {
    expect(tEventModel,isA<Event>());
  });
  
  group('fromJson', (){
    test(' form Json when status is success return valid model',() async{
      // arrange
      final Map<String,dynamic> jsonMap = 
          json.decode(fixture('/event/get_events_single_event.json'));
      // act
      final result = EventModel.fromJson(jsonMap);
      // assert
      expect(result,tEventModel);
    });
  });

}