import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/platform/network_info.dart';
import 'package:ironman/features/event/data/event/EventDetailModel.dart';
import 'package:ironman/features/event/data/event/EventModel.dart';
import 'package:ironman/features/event/data/event/event_remote_data_source.dart';
import 'package:ironman/features/event/data/event/event_repository_impl.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import 'package:mockito/mockito.dart';

class MockEventRemoteDataSource extends Mock implements EventRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  EventRepositoryImpl repository;
  MockEventRemoteDataSource mockEventRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockEventRemoteDataSource = MockEventRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = EventRepositoryImpl(
        remoteDataSource: mockEventRemoteDataSource,
        networkInfo: mockNetworkInfo);
  });

  final tEventModel = EventModel(
    eventId: 122987,
    eventCountryName: 'Poland',
    eventVenue: "",
    eventFinishDate: '1992-01-01',
    eventDate: '1992-01-01',
    eventTitle: "1992 POL Duathlon National Championships",
    eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png",
  );

  final tEvents = [tEventModel];

  // This refactoring allows to avoid repeats write when to return true or false networkInfo !
  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('get Events by query', () {

    final searchQuery = 'poland';
    final page = 1;
    final eventTense = EventTense.All;

    runTestsOnline((){
      test('get Events By query verify is remote data called',() async {
        // arrange
        when(mockEventRemoteDataSource.searchEventsByQuery(searchQuery, eventTense, page))
            .thenAnswer((_) async => tEvents );

        // act
        await repository.searchEventsByQuery(searchQuery, eventTense,page);

        // assert
        verify(mockEventRemoteDataSource.searchEventsByQuery(searchQuery, eventTense, page));
      });
    });

    runTestsOnline((){
      test(
          'get Events by query when the call to remote data source is successful return valid Event Model',
              () async {
            // assert
            when(mockEventRemoteDataSource.searchEventsByQuery(searchQuery,eventTense,page))
                .thenAnswer((_) async => tEvents);

            // act
            final result = await repository.searchEventsByQuery(searchQuery,eventTense,page);

            // assert
            verify(mockEventRemoteDataSource.searchEventsByQuery(searchQuery,eventTense,page));
            expect(result, equals(Right(tEvents)));
          });
    });

    runTestsOnline((){
      test(
          'get Events by query when call to remote data source is unsuccessful return ServerFailure',
              () async {
            // arrange
            when(mockEventRemoteDataSource.searchEventsByQuery(searchQuery, eventTense,page))
                .thenThrow(ServerExceptions(message: 'Error'));

            // act
            final result = await repository.searchEventsByQuery(searchQuery,eventTense,page);

            // assert
            // Check if method has been called event if throw exception !
            verify(mockEventRemoteDataSource.searchEventsByQuery(searchQuery,eventTense,page));
            expect(result, Left(ServerFailure()));
          });
    });

    runTestsOnline((){
      test('get Events by query when call to remote data source is empty repsonse return NoElementFailure',() async{

        // arrange
        when(mockEventRemoteDataSource.searchEventsByQuery(searchQuery,eventTense,page))
            .thenThrow(NoElementExceptions(message: 'No element'));

        // act
        final result = await repository.searchEventsByQuery(searchQuery,eventTense,page);

        // assert
        expect(result,Left(NoElementFailure()));
      });
    });

    runTestsOffline(() {
      test(
          'get Events by query when no internet connection return NoInternetFailure',
          () async {
        // arrange
        when(mockEventRemoteDataSource.searchEventsByQuery(searchQuery,eventTense,page))
            .thenThrow(NoInternetFailure());

        // act
        final result = await repository.searchEventsByQuery(searchQuery,eventTense,page);

        // assert
        verifyZeroInteractions(mockEventRemoteDataSource);
        expect(result, equals(Left(NoInternetFailure())));
      });
    });
  });


  final tEventSpecificationModel = EventSpecificationModel(name: '#name', id: 0, parentId: 0);
  final tEventSpecificationModel2 = EventSpecificationModel(name: '#name', id: 0, parentId: 0);
  List<EventSpecificationModel> eventsSpecModels = [tEventSpecificationModel,tEventSpecificationModel2];

  final tEventDetailModel = EventDetailModel(
    eventId: 122987,
    eventCountryName: 'Poland',
    eventVenue: "",
    eventFinishDate: '1992-01-01',
    eventDate: '1992-01-01',
    eventTitle: "1992 POL Duathlon National Championships",
    eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png",
    eventSpecifications: eventsSpecModels,
    eventWebSite: null,
    information: 'information'
  );

  group('get Event by id', (){

    runTestsOnline((){
      test('get Event by id when id is valid return valid Event',() async {

        // arrange
        when(mockEventRemoteDataSource.getEventById(any))
            .thenAnswer((realInvocation) async => tEventDetailModel);
        // act
        final result = await repository.getEventById(0);

        // assert
        verify(mockEventRemoteDataSource.getEventById(0));
        expect(result, equals(Right(tEventDetailModel)));

      });
    });

    runTestsOnline((){
      test('get Event by id when id is invalid return NoElementFailure',() async {

        // arrange
        when(mockEventRemoteDataSource.getEventById(any))
            .thenThrow(ServerExceptions(message: 'No element found'));
        // act
        final result = await repository.getEventById(0);

        // assert
        verify(mockEventRemoteDataSource.getEventById(0));
        expect(result, equals(Left(NoElementFailure())));

      });
    });

    runTestsOffline((){
      test('get Event by id when no internet connection return NoInternetFailure',() async {

        // arrange
        when(mockEventRemoteDataSource.getEventById(any))
            .thenThrow(NoInternetFailure());
        // act
        final result = await repository.getEventById(0);

        // assert
        verifyZeroInteractions(mockEventRemoteDataSource);
        expect(result, equals(Left(NoInternetFailure())));

      });
    });
  });
}