import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/data/event/event_local_data_source.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';
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

  // poprawnie się otwiera
  // Czy dobrze zapisuje
  // throw NoElementException when id / list is not found
  // czy dobrze działa z pagination <brzegowe przypadki !>
  // zwraca CacheException

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

  group('single Event',(){

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


  // 10 < 10 nie przejdzie 9 będzie osatnim indexem
  List<Event> _getTestEvents(int size, {int startIndex = 0}) {
    List<Event> _events = [];

    for (int i = 0; i < size; i++) {
      _events.add(Event(
          eventId: startIndex,
          eventTitle: 'EventTitle',
          eventDate: '21/03/2020',
          eventFinishDate: '21/03/2020',
          eventVenue: 'Krakow',
          eventCountryName: 'Poland',
          eventFlag:
              'https:\/\/f9ca11ef49c28681fc01-0acbf57e00c47a50e70a1acb89e86c89.ssl.cf1.rackcdn.com\/images\/icons\/au.png'));
      startIndex++;
    }

    print('get_TestEvents | size: $size | startIndex: $startIndex');
    print('\nEvent Id\'s');
    _events.forEach((element) {
      print(element.eventId);
    });

    return _events;
  }

}
