import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/features/event/data/event/EventModel.dart';
import 'package:ironman/features/event/data/event/event_hive.dart';
import 'package:ironman/features/event/data/event/event_local_data_source.dart';
import 'package:mockito/mockito.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockHiveBox extends Mock implements Box {}

void main(){
  MockHiveInterface mockHiveInterface;
  EventLocalDataSource eventLocalDataSource;
  MockHiveBox mockHiveBox;



  setUp((){
    mockHiveInterface = MockHiveInterface();
    mockHiveBox = MockHiveBox();
    eventLocalDataSource = HiveEventLocalDataSourceImpl(mockHiveBox);
  });

  test('open hive box should invoke openBox method',() async {
    // arrange
    when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockHiveBox);
    mockHiveInterface.openBox('any');
    verify(mockHiveInterface.openBox('any'));
  });

  final tEventModel1 = EventHive(
      eventId: 122987,
      eventTitle: "1992 POL Duathlon National Championships",
      eventVenue: "",
      eventCountryName: "Poland",
      eventDate: "1992-01-01",
      eventFinishDate: "1992-01-01",
      eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");

  final tEventModel2 = EventHive(
      eventId: 122986,
      eventTitle: "1992 POL Middle Distance Triathlon National Championships",
      eventVenue: "",
      eventCountryName: "Poland",
      eventDate: "1992-01-01",
      eventFinishDate: "1992-01-01",
      eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");
  final tEventModel3 = EventHive(
      eventId: 122985,
      eventTitle: "1992 POL Triathlon National Championships",
      eventVenue: "",
      eventCountryName: "Poland",
      eventDate: "1992-01-01",
      eventFinishDate: "1992-01-01",
      eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");

  List<EventHive> tEventModels = [tEventModel1, tEventModel2, tEventModel3];
  
  group('searchEventsByQuery', (){

    test('searchEventsByQuery should return list of events',() async {

      // arrange
      when(mockHiveInterface.openBox(any)).thenAnswer((_) async => mockHiveBox);

      String query = 'poland';
      int page = 1;

      when(mockHiveBox.get(query)).thenAnswer((_) => tEventModels);

      // act
      final result = await eventLocalDataSource.searchEventsByQuery(query, page);
      // assert
      expect(result,tEventModels);


    });

  

  });

}