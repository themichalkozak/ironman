import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/platform/network_info.dart';
import 'package:ironman/features/event/data/event/event_detailed_model.dart';
import 'package:ironman/features/event/data/event/EventModel.dart';
import 'package:ironman/features/event/data/event/event_local_data_source.dart';
import 'package:ironman/features/event/data/event/event_remote_data_source.dart';
import 'package:ironman/features/event/data/event/event_repository_impl.dart';
import 'package:mockito/mockito.dart';

class MockEventRemoteDataSource extends Mock implements EventRemoteDataSource {}

class MockEventLocalDataSource extends Mock implements EventLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  EventRepositoryImpl repository;
  MockEventRemoteDataSource mockEventRemoteDataSource;
  MockEventLocalDataSource mockEventLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockEventRemoteDataSource = MockEventRemoteDataSource();
    mockEventLocalDataSource = MockEventLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    repository = EventRepositoryImpl(
        remoteDataSource: mockEventRemoteDataSource,
        localDataSource: mockEventLocalDataSource,
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

  final tEventModelUpdated = EventModel(
    eventId: 122987,
    eventCountryName: 'Poland',
    eventVenue: "",
    eventFinishDate: '1992-01-02',
    eventDate: '1992-01-01',
    eventTitle: "1992 POL Duathlon National Championships",
    eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png",
  );

  final tEvents = [tEventModel];
  final tEventsUpdated = [tEventModelUpdated];


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

    runTestsOnline(() {
      test('searchEventsByQuery verify is remote data called', () async* {
        // arrange
        when(mockEventRemoteDataSource.searchEventsByQuery(
                searchQuery, page))
            .thenAnswer((_) async => tEvents);

        // act
        repository.searchEventsByQuery(searchQuery, page);

        // assert
        verify(mockEventRemoteDataSource.searchEventsByQuery(
            searchQuery, page));
      });
    });

    runTestsOnline(() {
      test('searchEventsByQuery when is internet connection should call cacheEvents fun',
          () async* {
        // arrange
        // when remoteDataSource -> correctModel
        when(mockEventRemoteDataSource.searchEventsByQuery(
                searchQuery, page))
            .thenAnswer((_) async => tEvents);

        when(mockEventLocalDataSource.searchEventsByQuery(
            any, any))
            .thenAnswer((_) async => null);
        // act
        // invoke api remoteDataSource.searchQueryCall
        repository.searchEventsByQuery(searchQuery, page);
        // assert
        // verify is remoteDataSource.searchQuert call
        verify(mockEventRemoteDataSource.searchEventsByQuery(
            searchQuery, page));
        verify(mockEventLocalDataSource.cacheEvents(tEvents, page));
            // verify is cacheDataSource.cacheEvents call with correct params
      });
    });

    runTestsOnline(() {
      test(
          'searchEventsByQuery when is internet connection return list of events',
          (){
        // assert
        when(mockEventRemoteDataSource.searchEventsByQuery(
                searchQuery, page))
            .thenAnswer((_) async => tEventsUpdated);

        when(mockEventLocalDataSource.searchEventsByQuery(searchQuery, page))
            .thenAnswer((_) async => tEvents);

        // act
        final result =
            repository.searchEventsByQuery(searchQuery, page);

        // assert
        // verify(mockEventRemoteDataSource.searchEventsByQuery(
        //     searchQuery, page));
        expect(result, emitsInOrder([Right(tEvents),Right(tEvents),emitsDone]));
      });
    });

    runTestsOffline((){
      test('searchEventsByQuery when is no internet connection return cached list of events',() async*{

        // arrange
        when(mockEventLocalDataSource.searchEventsByQuery(searchQuery, page))
            .thenAnswer((_) async => tEvents);

        // act
        final result = repository.searchEventsByQuery(searchQuery, page);

        // assert
        verify(mockEventLocalDataSource.searchEventsByQuery(searchQuery, page));
        expect(result,emitsInOrder([Right(tEvents),emitsDone]));

      });
    });

    // when isNotInternetConnection and is ServerException should emit ServerFailure !

    runTestsOnline(() {
      test(
          'searchEventsByQuery when call to remote data source is unsuccessful return ServerFailure',
          () async* {
        // arrange
        when(mockEventRemoteDataSource.searchEventsByQuery(
                searchQuery, page))
            .thenThrow(ServerExceptions(message: 'Error'));

        // act
        final result =
            repository.searchEventsByQuery(searchQuery, page);

        // assert
        // Check if method has been called event if throw exception !
        verify(mockEventRemoteDataSource.searchEventsByQuery(
            searchQuery, page));
        expect(result, emitsInOrder([Left(ServerFailure())]));
      });
    });

    runTestsOffline((){
      test('searchEventsByQuery when throw Cache Exception return cacheFailure',() async* {

        // arrange
        when(mockEventLocalDataSource.searchEventsByQuery(searchQuery, page))
            .thenThrow(CacheException(message: CACHE_FAILURE));
        // act
        final result = repository.searchEventsByQuery(searchQuery, page);
        // assert
        expect(result, emitsInOrder([Left(CacheFailure(error: CACHE_FAILURE))]));
      });
    });
  });

  final tEventSpecificationModel =
      EventSpecificationModel(name: '#name', id: 0, parentId: 0);
  final tEventSpecificationModel2 =
      EventSpecificationModel(name: '#name', id: 0, parentId: 0);
  List<EventSpecificationModel> eventsSpecModels = [
    tEventSpecificationModel,
    tEventSpecificationModel2
  ];

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
      information: 'information');

  group('get Event by id', () {
    runTestsOnline(() {
      test('get Event by id when id is valid return valid Event', () async {
        // arrange
        when(mockEventRemoteDataSource.getEventById(any))
            .thenAnswer((realInvocation) async => tEventDetailModel);
        // act
        final result = await repository.searchEventById(0);

        // assert
        verify(mockEventRemoteDataSource.getEventById(0));
        expect(result, equals(Right(tEventDetailModel)));
      });
    });

    runTestsOnline(() {
      test('get Event by id when id is invalid return NoElementFailure',
          () async {
        // arrange
        when(mockEventRemoteDataSource.getEventById(any))
            .thenThrow(ServerExceptions(message: 'No element found'));
        // act
        final result = await repository.searchEventById(0);

        // assert
        verify(mockEventRemoteDataSource.getEventById(0));
        expect(result, equals(Left(NoElementFailure())));
      });
    });

    runTestsOffline((){
      test('get Event by id when is internet connection and data is available return valid cached EventDetail model',() async {

        // arrange
        final id = 0;

        when(mockEventLocalDataSource.searchEventById(any))
            .thenAnswer((realInvocation) async => tEventDetailModel);

        // act
        final result = await repository.searchEventById(id);

        // assert

        expect(result,Right(tEventDetailModel));
      });
    });

    runTestsOffline((){
      test('get Event By id when throw CacheException return CacheFailure',() async {

        // arrange
        when(mockEventLocalDataSource.searchEventById(any)).thenThrow(CacheException(message: CACHE_FAILURE));

        // act
        final result = await repository.searchEventById(0);

        // assert

        expect(result,Left(CacheFailure(error: CACHE_FAILURE)));

      });
    });
  });
}
