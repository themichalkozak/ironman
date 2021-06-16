import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/event_repository.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import 'package:ironman/features/event/domain/useCases/get_events.dart';
import 'package:mockito/mockito.dart';


class MockEventRepository extends Mock implements EventRepository {}

void main() {
  GetEvents useCase;
  MockEventRepository mockEventRepository;

  setUp(() {
    mockEventRepository = MockEventRepository();
    useCase = GetEvents(mockEventRepository);
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

  test('get events when is internet connection should return list Events',
      () async {
    // 'On the fly' eventRepository implementation using Mocito Library
    // When getEvents has called with any arguments always return Right 'sites' object
    // contains test object

    when(mockEventRepository.getEvents(any,any))
        .thenAnswer((_) async => Right(events));
// act
    // call not-yet existent method
    final result = await useCase(GetEventsParams(eventTense: EventTense.All));
    // useCase simply return whatever is in repository
    expect(result, Right(events));
    // verify is method has been called in eventRepository
    verify(mockEventRepository.getEvents(EventTense.All,1));
    // check if only above method has been called and nothing more
    verifyNoMoreInteractions(mockEventRepository);
  });

  test('get events when is no internet connection should return failure ',
      () async {
    when(mockEventRepository.getEvents(any,any))
        .thenAnswer((_) async => Left(NoInternetFailure()));

        final result = await useCase(GetEventsParams(eventTense: EventTense.All));

        expect(result, Left(NoInternetFailure()));

        verify(mockEventRepository.getEvents(EventTense.All,1));

        verifyNoMoreInteractions(mockEventRepository);
  });

}
