import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/error/failure.dart';
import '../../../../../lib/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/domain/event_repository.dart';
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

  mockSearchEventsByQuerySuccessResult(String searchQuery) async {
    when(mockEventRepository.searchEventsByQuery(searchQuery, 1))
        .thenAnswer((_) async* {
      yield Right(events);
    });
  }

  final page = 1;

  test(
      'search events by query when is not null and empty should return list Events',
      () async {
    // arrange

    final searchQuery = '';
    SearchEventsByQueryParams params =
        SearchEventsByQueryParams(page: page, query: searchQuery);

    mockSearchEventsByQuerySuccessResult(searchQuery);
    // act

    final result = useCase(params);
    // useCase simply return whatever is in repository
    expect(result, emitsInOrder([Right(events)]));
    // verify is method has been called in eventRepository
    verify(mockEventRepository.searchEventsByQuery(searchQuery, page));
    // check if only above method has been called and nothing more
    verifyNoMoreInteractions(mockEventRepository);
  });

  void mockSearchEventsQueryFailureResult(Failure failure) async {
    when(mockEventRepository.searchEventsByQuery(any, any))
        .thenAnswer((_) async* {
      yield Left(failure);
    });
  }

  final searchQuery = '';
  final params = SearchEventsByQueryParams(page: page, query: searchQuery);

  test(
      'search events by query when is no internet connection should return NoInternetFailure',
      (){
    // assert
    mockSearchEventsQueryFailureResult(NoInternetFailure());

    // act
    final result = useCase(params);

    expect(result, emitsInOrder([Left(NoInternetFailure())]));

    verify(mockEventRepository.searchEventsByQuery(searchQuery, page));

    verifyNoMoreInteractions(mockEventRepository);
  });

  test('search events by query when data is null return NoElementFailure',
      () {
    // assert
    mockSearchEventsQueryFailureResult(NoElementFailure());

    final result = useCase(params);

    expect(result, emitsInOrder([Left(NoElementFailure())]));

    verify(mockEventRepository.searchEventsByQuery(searchQuery, page));

    verifyNoMoreInteractions(mockEventRepository);
  });

  test(
      'search events by query when is server failure should return serverFailure',
      () {
    // assert
    mockSearchEventsQueryFailureResult(NetworkFailure());

    final result = useCase(params);

    expect(result, emitsInOrder([Left(NetworkFailure())]));

    verify(mockEventRepository.searchEventsByQuery(searchQuery, page));

    verifyNoMoreInteractions(mockEventRepository);
  });
}
