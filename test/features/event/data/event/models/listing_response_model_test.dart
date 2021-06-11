import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/listing_response_model.dart';
import 'package:ironman/features/event/data/event/EventModel.dart';
import '../../../../../fixtures/fixture_reader.dart';

void main() {

  EventModel eventModel1 = EventModel(eventId: 149007,
      eventTitle: '1985 Ulster ETU Triathlon Team Relay European Championships',
      eventDate: '1985-06-08',
      eventFinishDate: '1985-06-08',
      eventVenue: 'Ulster',
      eventCountryName: 'Ireland',
      eventFlag: 'https://triathlon-images.imgix.net/images/icons/ie.png');

  EventModel eventModel2 = EventModel(eventId: 140860,
      eventTitle: '1985 Immenstadt ETU Triathlon European Championships',
      eventDate: '1985-07-27',
      eventFinishDate: '1985-07-27',
      eventVenue: 'Immenstadt',
      eventCountryName: 'Germany',
      eventFlag: 'https://triathlon-images.imgix.net/images/icons/de.png');

  EventModel eventModel3 = EventModel(eventId: 140949,
      eventTitle: '1985 Almere ETU Long Distance Triathlon European Championships',
      eventDate: '1985-08-17',
      eventFinishDate: '1985-08-17',
      eventVenue: 'Almere',
      eventCountryName: 'Netherlands',
      eventFlag: 'https://triathlon-images.imgix.net/images/icons/nl.png');

  List<EventModel> eventModels = [eventModel1, eventModel2, eventModel3];

  ListingResponseModel tResponseModel = ListingResponseModel(
      status: 'success', currentPage: 1, lastPage: 1481, data: eventModels);

  test('fromJson when status is success return valid ListingResponseModel',(){
    // arrange
    final Map<String,dynamic> jsonMap = jsonDecode(fixture('event/get_events_3_per_page_ordered_by_asc.json'));
    // act
    final result = ListingResponseModel.fromJson(jsonMap);
    // assert
    expect(result,tResponseModel);
  });


}