import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/event_repository.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import 'package:ironman/features/event/domain/useCases/search_events_by_query.dart';
import 'package:mockito/mockito.dart';

class MockEventRepository extends Mock implements EventRepository {}

void main() {
  SearchEventsByQuery useCase;
  MockEventRepository mockEventRepository;

  setUp(() {
    mockEventRepository = MockEventRepository();
    useCase = SearchEventsByQuery(mockEventRepository);
  });

  final List<Event> events = [
    Event(
        eventId: 0,
        eventTitle: '#EventTitle0',
        eventDate: DateTime.now().toString(),
        eventFinishDate: DateTime.now().toString(),
        eventVenue: 'London',
        eventCountryName: 'England',
        eventFlag: 'https://triathlon-images.imgix.net/images/icons/gb.png'),
    Event(
        eventId: 0,
        eventTitle: '#EventTitle0',
        eventDate: DateTime.now().toString(),
        eventFinishDate: DateTime.now().toString(),
        eventVenue: 'London',
        eventCountryName: 'England',
        eventFlag: 'https://triathlon-images.imgix.net/images/icons/gb.png'),
  ];

  SearchEventsByQueryParams params =
      SearchEventsByQueryParams(query: '', eventTense: EventTense.All);

  test(
      'search events by query when is not null and empty should return list Events',
      () async {
    // 'On the fly' eventRepository implementation using Mocito Library
    // When getEvents has called with any arguments always return Right 'sites' object
    // contains test object
    // arrange
    when(mockEventRepository.searchEventsByQuery(any, any))
        .thenAnswer((_) async => Right(events));
// act
    // call not-yet existent method
    final result = await useCase(params);
    // useCase simply return whatever is in repository
    expect(result, Right(events));
    // verify is method has been called in eventRepository
    verify(mockEventRepository.searchEventsByQuery('', EventTense.All));
    // check if only above method has been called and nothing more
    verifyNoMoreInteractions(mockEventRepository);
  });

  test(
      'search events by query when is not empty should return valid list events',
      () async {
    // arrange

    final queryParam = 'England';
    final eventTenseParam = EventTense.All;
    final params = SearchEventsByQueryParams(
        eventTense: eventTenseParam, query: queryParam);

    when(mockEventRepository.searchEventsByQuery(queryParam, eventTenseParam))
        .thenAnswer((_) async => Right(events));

    // act
    final result = await useCase(params);

    // assert
    expect(result, Right(events));

    verify(mockEventRepository.searchEventsByQuery(queryParam, eventTenseParam));
    // check if only above method has  been called and nothing more
    verifyNoMoreInteractions(mockEventRepository);
  });

  test(
      'search events by query is not empty should return valid list events',
          () async {
        // arrange

        final queryParam = 'England';
        final eventTenseParam = EventTense.All;
        final params = SearchEventsByQueryParams(
            eventTense: eventTenseParam, query: queryParam);

        when(mockEventRepository.searchEventsByQuery(queryParam, eventTenseParam))
            .thenAnswer((_) async => Right(events));

        // act
        final result = await useCase(params);

        // assert
        expect(result, Right(events));

        verify(mockEventRepository.searchEventsByQuery(queryParam, eventTenseParam));
        // check if only above method has  been called and nothing more
        verifyNoMoreInteractions(mockEventRepository);
      });

  test(
      'fetch new page result should increment page value',
          () async {
        // arrange
            final queryParam = "Poland";
            final eventTenseParam = EventTense.All;
            when(mockEventRepository.searchEventsByQuery(queryParam, eventTenseParam))
            .thenAnswer((_) async => Right(events));

            final params = SearchEventsByQueryParams(
                eventTense: eventTenseParam, query: queryParam);
        // act
            await useCase.call(params);
            useCase.fetchNextPageResult();
            expect(2,useCase.page);
        // assert
      });

  test(
      'fetch new page when isInitialState is false should throw noInitialStateFailure',
          () async {
        // arrange
        final queryParam = "Poland";
        final eventTenseParam = EventTense.All;
        when(mockEventRepository.searchEventsByQuery(queryParam, eventTenseParam))
            .thenAnswer((_) async => any);
        // act
        final result = await useCase.fetchNextPageResult();
        expect(result,Left(NoInitialStateFailure()));
        // assert
      });

  test(
      'search events by query when is no internet connection should return NoInternetFailure',
      () async {
    when(mockEventRepository.searchEventsByQuery(any, any))
        .thenAnswer((_) async => Left(NoInternetFailure()));

    final result = await useCase(params);

    expect(result, Left(NoInternetFailure()));

    verify(mockEventRepository.searchEventsByQuery(any, any));

    verifyNoMoreInteractions(mockEventRepository);
  });

  test('search events by query when data is null return NoElementFailure',
      () async {
    when(mockEventRepository.searchEventsByQuery(any, any))
        .thenAnswer((_) async => Left(NoElementFailure()));

    final result = await useCase(params);

    expect(result, Left(NoElementFailure()));

    verify(mockEventRepository.searchEventsByQuery(any, any));

    verifyNoMoreInteractions(mockEventRepository);
  });

  test(
      'search events by query when is server failure should return serverFailure',
      () async {
    when(mockEventRepository.searchEventsByQuery(any, any))
        .thenAnswer((_) async => Left(ServerFailure()));

    final result = await useCase(params);

    expect(result, Left(ServerFailure()));

    verify(mockEventRepository.searchEventsByQuery(any, any));

    verifyNoMoreInteractions(mockEventRepository);
  });
}
