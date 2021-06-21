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

  void mockSearchEventsByQuerySuccessResult(String searchQuery) async {
    when(mockEventRepository.searchEventsByQuery(
            searchQuery, EventTense.All, 1))
        .thenAnswer((_) async => Right(events));
  }

  final eventTense = EventTense.All;
  final page = 1;

  test(
      'search events by query when is not null and empty should return list Events',
      () async {
    // arrange

    final searchQuery = '';
    SearchEventsByQueryParams params =
        SearchEventsByQueryParams(query: searchQuery, eventTense: eventTense);

    mockSearchEventsByQuerySuccessResult(searchQuery);
    // act

    final result = await useCase(params);
    // useCase simply return whatever is in repository
    expect(result, Right(events));
    // verify is method has been called in eventRepository
    verify(
        mockEventRepository.searchEventsByQuery(searchQuery, eventTense, page));
    // check if only above method has been called and nothing more
    verifyNoMoreInteractions(mockEventRepository);
  });

  test(
      'search events by query when is not empty should return valid list events',
      () async {
    // arrange

    final queryParam = 'England';
    final params =
        SearchEventsByQueryParams(eventTense: eventTense, query: queryParam);

    mockSearchEventsByQuerySuccessResult(queryParam);

    // act
    final result = await useCase(params);

    // assert
    expect(result, Right(events));

    verify(
        mockEventRepository.searchEventsByQuery(queryParam, eventTense, page));
    // check if only above method has  been called and nothing more
    verifyNoMoreInteractions(mockEventRepository);
  });

  test('fetch new page result should increment page value', () async {
    // arrange
    final queryParam = "Poland";
    final eventTenseParam = EventTense.All;

    mockSearchEventsByQuerySuccessResult(queryParam);

    final params = SearchEventsByQueryParams(
        eventTense: eventTenseParam, query: queryParam);
    // act
    await useCase.call(params);
    useCase.fetchNextPageResult();
    expect(2, useCase.page);
    // assert
  });

  test(
      'fetch new page when isInitialState is false should throw noInitialStateFailure',
      () async {
    // arrange
    final queryParam = "Poland";
    mockSearchEventsByQuerySuccessResult(queryParam);

    // act
    final result = await useCase.fetchNextPageResult();

    // assert
    expect(result, Left(NoInitialStateFailure()));
  });

  void mockSearchEventsQueryFailureResult(Failure failure) {
    when(mockEventRepository.searchEventsByQuery(any, any, any))
        .thenAnswer((_) async => Left(failure));
  }
  final searchQuery = '';
  final params = SearchEventsByQueryParams(eventTense: eventTense,query: searchQuery);

  test(
      'search events by query when is no internet connection should return NoInternetFailure',
      () async {
    // assert
    mockSearchEventsQueryFailureResult(NoInternetFailure());

    // act
    final result = await useCase(params);

    expect(result, Left(NoInternetFailure()));

    verify(mockEventRepository.searchEventsByQuery(searchQuery, eventTense,page));

    verifyNoMoreInteractions(mockEventRepository);
  });

  test('search events by query when data is null return NoElementFailure',
      () async {

    // assert
        mockSearchEventsQueryFailureResult(NoElementFailure());

    final result = await useCase(params);

    expect(result, Left(NoElementFailure()));

    verify(mockEventRepository.searchEventsByQuery(searchQuery, eventTense,page));

    verifyNoMoreInteractions(mockEventRepository);
  });



  test(
      'search events by query when is server failure should return serverFailure',
      () async {

        // assert
        mockSearchEventsQueryFailureResult(ServerFailure());

    final result = await useCase(params);

    expect(result, Left(ServerFailure()));

    verify(mockEventRepository.searchEventsByQuery(searchQuery, eventTense,page));

    verifyNoMoreInteractions(mockEventRepository);
  });

  test(
      'search events by query when is no initial State failure should return noInitialStateFailure',
          () async {

        // assert
        mockSearchEventsQueryFailureResult(NoInitialStateFailure());

        final result = await useCase.fetchNextPageResult();

        expect(result, Left(NoInitialStateFailure()));

        verifyNoMoreInteractions(mockEventRepository);
      });

  test('update Params when params is valid return valid params',() async {

    // arrange
    final searchQuery = 'Poland';
    final eventTense = EventTense.All;
    final params = SearchEventsByQueryParams(eventTense: eventTense,query: searchQuery);
    mockSearchEventsByQuerySuccessResult(searchQuery);
    // act
    await useCase(params);

    // assert
    expect(params,useCase.params);
  });

  test('search events by query when is new query should page reset to 1',() async {

    // arrange
    final firstQuery = "Poland";
    final secondQuery = "Denmark";
    final eventTense = EventTense.All;
    SearchEventsByQueryParams params = SearchEventsByQueryParams(eventTense: eventTense,query: firstQuery);
    mockSearchEventsByQuerySuccessResult(firstQuery);

    // act
    await useCase(params);
    expect(useCase.page,1);
    await useCase.fetchNextPageResult();
    expect(useCase.page,2);


    params = SearchEventsByQueryParams(eventTense: eventTense,query: secondQuery);
    await useCase(params);
    expect(useCase.page,1);
  });


}
