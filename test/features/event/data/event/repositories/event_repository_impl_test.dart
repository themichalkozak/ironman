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

  final tEventModel = EventDto(
    eventId: 122987,
    eventCountryName: 'Poland',
    eventVenue: "",
    eventFinishDate: '1992-01-01',
    eventDate: '1992-01-01',
    eventTitle: "1992 POL Duathlon National Championships",
    eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png",
  );

  final tEventModelUpdated = EventDto(
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
      test(
          'searchEventsByQuery when is internet connection return list of events',
          () {
        // assert
        var callCount = 0;
        when(mockEventRemoteDataSource.searchEventsByQuery(searchQuery, page))
            .thenAnswer((_) async => [tEventModelUpdated]);

        when(mockEventLocalDataSource.searchEventsByQuery(searchQuery, page))
            .thenAnswer((_) async => [tEvents, tEventsUpdated][callCount++]);

        // act
        final result = repository.searchEventsByQuery(searchQuery, page);

        // assert

        expect(result,
            emitsInOrder([Right(tEvents), Right(tEventsUpdated), emitsDone]));
      });
    });

    runTestsOffline(() {
      test(
          'searchEventsByQuery when is no internet connection return cached list of events',
          () {
        // arrange
        when(mockEventLocalDataSource.searchEventsByQuery(searchQuery, page))
            .thenAnswer((_) async => tEvents);

        // act
        final result = repository.searchEventsByQuery(searchQuery, page);

        // assert
        expect(result, emitsInOrder([Right(tEvents), emitsDone]));
      });
    });

    runTestsOnline(() {
      test(
          'searchEventsByQuery when call to remote data source is unsuccessful return ServerFailure',
          () {
        // arrange
        when(mockEventLocalDataSource.searchEventsByQuery(searchQuery, page))
            .thenAnswer((_) async => tEvents);

        when(mockEventRemoteDataSource.searchEventsByQuery(searchQuery, page))
            .thenThrow(ServerExceptions(message: 'Error'));

        // act
        final result = repository.searchEventsByQuery(searchQuery, page);

        expect(result, emitsInOrder([Right(tEvents), Left(NetworkFailure())]));
      });
    });

    runTestsOffline(() {
      test('searchEventsByQuery when throw Cache Exception return cacheFailure',
          () async {
        // arrange
        when(mockEventLocalDataSource.searchEventsByQuery(searchQuery, page))
            .thenThrow(CacheException(message: CACHE_FAILURE));
        // act
        final result = repository.searchEventsByQuery(searchQuery, page);
        // assert
        expect(
            result, emitsInOrder([Left(CacheFailure(error: CACHE_FAILURE))]));
      });
    });

    runTestsOnline(() {
      test(
          'searchEventsByQuery when throw TimeoutException return timeoutFailure',
          () async {
        // arrange

        when(mockEventLocalDataSource.searchEventsByQuery(searchQuery, page))
            .thenAnswer((_) async => tEvents);

        when(mockEventRemoteDataSource.searchEventsByQuery(searchQuery, page))
            .thenThrow(TimeoutException(message: TIMEOUT_FAILURE_MESSAGE));
        // act
        final result = repository.searchEventsByQuery(searchQuery, page);
        // assert
        expect(result, emitsInOrder([Right(tEvents), Left(TimeoutFailure())]));
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
            .thenAnswer((_) async => tEventDetailModel);
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

    runTestsOffline(() {
      test(
          'get Event by id when is internet connection and data is available return valid cached EventDetail model',
          () async {
        // arrange
        final id = 0;

        when(mockEventLocalDataSource.searchEventById(any))
            .thenAnswer((realInvocation) async => tEventDetailModel);

        // act
        final result = await repository.searchEventById(id);

        // assert

        expect(result, Right(tEventDetailModel));
      });
    });

    runTestsOffline(() {
      test('get Event By id when throw CacheException return CacheFailure',
          () async {
        // arrange
        when(mockEventLocalDataSource.searchEventById(any))
            .thenThrow(CacheException(message: CACHE_FAILURE));

        // act
        final result = await repository.searchEventById(0);

        // assert

        expect(result, Left(CacheFailure(error: CACHE_FAILURE)));
      });
    });
  });

  // should return CacheFailure after throw CacheException
  // should return valid list of upcoming events from api call when is internet
  // should return valid cached list of upcoming events when is not internet connection
  // should return ServerFailure after throw ServerException

  // should return TimeoutFailure after throw TimeoutException
  // should invoke save Cache

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

  final tEventModel5 = EventDto(
      eventId: 122912,
      eventTitle: "2021 England Triathlon National Championships",
      eventVenue: "",
      eventCountryName: "England",
      eventDate: "2021-10-01",
      eventFinishDate: "2021--01",
      eventFlag: "https://triathlon-images.imgix.net/images/icons/gb.png");

  List<EventDto> tEventModels = [
    tEventModel1,
    tEventModel2,
    tEventModel3,
    tEventModel4
  ];
  List<EventDto> tFilteredEventModels = [tEventModel4];
  List<EventDto> tUpdatedFilteredEventModels = [tEventModel5];

  group('get upcoming events by query', () {
    final String queryParam = '';
    final page = 1;
    final formattedDateTime = '2021-08-07';
    final DateTime dateTime = DateTime(2021, 8, 7);

    runTestsOffline(() {
      test(
          'search upcoming events by query when is CacheException and no internet connection yield Left(CacheFailure)',
          () async {
        when(mockEventLocalDataSource.searchEventsByQuery(
                queryParam, page, dateTime))
            .thenThrow(CacheException(message: CACHE_FAILURE));

        final result =
            repository.searchUpcomingEventsByQuery(queryParam, page, dateTime);

        expect(
            result,
            emitsInOrder(
                [Left(CacheFailure(error: CACHE_FAILURE)), emitsDone]));
      });
    });

    runTestsOnline(() {
      test(
          'search upcoming events by query when is CacheException and internet connection yield Left(CacheFailure)',
          () async {
        when(mockEventLocalDataSource.searchEventsByQuery(
                queryParam, page, dateTime))
            .thenThrow(CacheException(message: CACHE_FAILURE));

        final result =
            repository.searchUpcomingEventsByQuery(queryParam, page, dateTime);

        expect(
            result,
            emitsInOrder(
                [Left(CacheFailure(error: CACHE_FAILURE)), emitsDone]));
      });
    });

    runTestsOnline(() {
      test(
          'search upcoming events by query when is internet connection should emitInOrder [tCachedFilteredEvents,tCachedUpdatedFilteredEvents',
          () async {
        // arrange
        int callCount = 0;
        when(mockEventLocalDataSource.searchEventsByQuery(
                queryParam, page, dateTime))
            .thenAnswer((_) async => [
                  tFilteredEventModels,
                  tUpdatedFilteredEventModels
                ][callCount++]);

        when(mockEventRemoteDataSource.searchUpcomingEventsByQuery(
                queryParam, page, formattedDateTime))
            .thenAnswer((_) async => tUpdatedFilteredEventModels);

        // act
        final result =
            repository.searchUpcomingEventsByQuery(queryParam, page, dateTime);

        // assert
        expect(
            result,
            emitsInOrder([
              Right(tFilteredEventModels),
              Right(tUpdatedFilteredEventModels),
              emitsDone
            ]));
      });
    });

    runTestsOffline(() {
      test(
          'search upcoming events when is no internet return cached list of events',
          () async {
        when(mockEventLocalDataSource.searchEventsByQuery(
                queryParam, page, dateTime))
            .thenAnswer((_) async => tUpdatedFilteredEventModels);

        final result =
            repository.searchUpcomingEventsByQuery(queryParam, page, dateTime);

        expect(result, emitsInOrder([Right(tUpdatedFilteredEventModels)]));
      });
    });

    runTestsOnline(() {
      test(
          'search upcoming events when occurred ServerException return ServerFailure',
          () async {
        // assert
        when(mockEventLocalDataSource.searchEventsByQuery(
                queryParam, page, dateTime))
            .thenAnswer((_) async => tUpdatedFilteredEventModels);

        when(mockEventRemoteDataSource.searchUpcomingEventsByQuery(
                queryParam, page, formattedDateTime))
            .thenThrow(TimeoutException(message: TIMEOUT_FAILURE_MESSAGE));

        // act
        final result =
            repository.searchUpcomingEventsByQuery(queryParam, page, dateTime);

        expect(
            result,
            emitsInOrder(
                [Right(tUpdatedFilteredEventModels),Left(TimeoutFailure(error: TIMEOUT_FAILURE_MESSAGE))]));
      });
    });

    runTestsOnline(() {
      test(
          'search upcoming events when occurred TimeoutException return TimeoutFailure',
          () async {
        // assert
        when(mockEventRemoteDataSource.searchUpcomingEventsByQuery(
                queryParam, page, formattedDateTime))
            .thenThrow(TimeoutException(message: TIMEOUT_FAILURE_MESSAGE));

        when(mockEventLocalDataSource.searchEventsByQuery(
                queryParam, page, dateTime))
            .thenAnswer((_) async => tUpdatedFilteredEventModels);

        // act
        final result =
            repository.searchUpcomingEventsByQuery(queryParam, page, dateTime);

        expect(
            result,
            emitsInOrder([
              Right(tUpdatedFilteredEventModels),
              Left(TimeoutFailure(error: TIMEOUT_FAILURE_MESSAGE))
            ]));
      });
    });
  });
}
