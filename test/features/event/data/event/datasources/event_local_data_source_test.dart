import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';
import '../../../../../../lib/features/event/business/domain/models/EventModel.dart';
import 'package:ironman/features/event/data/event/event_local_data_source.dart';
import '../../../../../../lib/features/event/business/domain/models/event.dart';
import '../../../../../../lib/features/event/business/domain/models/event_detail.dart';
import 'package:mockito/mockito.dart';

class MockEventBox extends Mock implements Box {}

class MockSingleEventBox extends Mock implements Box {}

void main() {
  Box eventBox;
  Box singleEventBox;
  EventLocalDataSource eventLocalDataSource;

  setUp(() {
    eventBox = MockEventBox();
    singleEventBox = MockSingleEventBox();
    eventLocalDataSource = HiveEventLocalDataSourceImpl(
        eventBox,singleEventBox);
  });


  group('get Events',(){

    final tEventModel1 = EventDto(
        eventId: 122987,
        eventTitle: "1992 POL Duathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");

    final tEventModel2 = EventDto(
        eventId: 122986,
        eventTitle: "1992 POL Middle Distance Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");
    final tEventModel3 = EventDto(
        eventId: 122985,
        eventTitle: "1992 POL Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");


    final tEventModel4 = EventDto(
        eventId: 122985,
        eventTitle: "1992 England Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "England",
        eventDate: "2021-09-01",
        eventFinishDate: "2021-09-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/gb.png");

    List<EventDto> tEventModels = [tEventModel1, tEventModel2, tEventModel3,tEventModel4];
    List<EventDto> tFilteredEventModels = [tEventModel4];

    String query = '';
    int page = 1;
    DateTime dateTime = DateTime(2021,8,7);

    test('searchEventsByQuery return List of Events',() async {
      // arrange
      when(eventBox.values).thenAnswer((_) => tEventModels);

      // act
      final result = await eventLocalDataSource.searchEventsByQuery(query, page);

      // assert
      expect(result,tEventModels);
    });

    test('searchUpcomingEventsByQuery return List of Events after now ',() async {

      // arrange
      when(eventBox.values).thenAnswer((_) => tEventModels);

      // act
      final result = await eventLocalDataSource.searchEventsByQuery(query, page,dateTime);

      // assert
      expect(result,tFilteredEventModels);
    });

  });

  group('single Event',(){

    final testListEventSpec = [EventSpecification('Triathlon',357,null)];

    final testEventDetail = EventDetail(
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

    test('cache single event when model is register should call save box method',(){
      eventLocalDataSource.cacheSingleEvent(testEventDetail);

      verify(singleEventBox.put(testEventDetail.eventId, testEventDetail));
    });


    test('searchEventById when data is available should return valid EventDetail',() async {

      // arrange
      when(singleEventBox.get(any)).thenAnswer((_) async => testEventDetail);

      // act
      final result = await eventLocalDataSource.searchEventById(testEventDetail.eventId);

      // assert

      expect(result,testEventDetail);
    });

    test('searchEventById when data is not available should throw Cache Exception',() async {

      // arrange
      when(singleEventBox.get(any)).thenThrow(CacheException(message: CACHE_FAILURE));

      // act
      final call = eventLocalDataSource.searchEventById(testEventDetail.eventId);

      // assert

      expect(() => call, throwsA(isA<CacheException>()));

    });
  });


}
