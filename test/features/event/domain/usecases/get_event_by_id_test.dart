import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/error/failure.dart';
import '../../../../../lib/features/event/business/domain/models/event_detail.dart';
import 'package:ironman/features/event/domain/event_repository.dart';
import 'package:ironman/features/event/domain/useCases/get_event_by_id_test.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';
import 'package:mockito/mockito.dart';

class MockEventRepository extends Mock implements EventRepository {}

void main() {
  GetEventById useCase;
  MockEventRepository mockEventRepository;

  setUp(() {
    mockEventRepository = MockEventRepository();
    useCase = GetEventById(mockEventRepository);
  });

  final testListEventSpec = [EventSpecification('#Name', 0, 0)];

  final testEventDetail = EventDetail(
      eventId: 0,
      eventTitle: '#TestEvent',
      eventDate: DateTime.now().toString(),
      eventFinishDate: DateTime.now().toString(),
      eventVenue: 'London',
      eventCountryName: 'England',
      eventFlag: 'https://triathlon-images.imgix.net/images/icons/gb.png',
      eventSpecifications: testListEventSpec,
      eventWebSite:
          'https://web.archive.org/web/20051231100000/http://www.sater-triathlon.com',
      information: 'information');

  test(
      'get Event by id when is internet connection and id equals 0 should return Right with Event',
      () async {
    // 'On the fly' eventRepository implementation using Mocito Library
    // contains test object

    when(mockEventRepository.searchEventById(0))
        .thenAnswer((_) async => Right(testEventDetail));
// act
    // call not-yet existent method
    final result = await useCase(GetEventByIdParams(id: 0));
    // useCase simply return whatever is in repository
    expect(result, Right(testEventDetail));
    // verify is method has been called in eventRepository
    verify(mockEventRepository.searchEventById(0));
    // check if only above method has been called and nothing more
    verifyNoMoreInteractions(mockEventRepository);
  });

  final failureNoInternetConnection = Failure(error: NO_INTERNET_FAILURE);

  test(
      'get Event by id  when is no internet connection and id equals 0 should return Failure',
          () async {
        // 'On the fly' eventRepository implementation using Mocito Library
        when(mockEventRepository.searchEventById(0))
            .thenAnswer((_) async => Left(failureNoInternetConnection));
        // act
        // call not-yet existent method
        final result = await useCase(GetEventByIdParams(id: 0));
        // useCase simply return whatever is in repository
        expect(result, Left(failureNoInternetConnection));
        // verify is method has been called in eventRepository
        verify(mockEventRepository.searchEventById(0));
        // check if only above method has been called and nothing more
        verifyNoMoreInteractions(mockEventRepository);
      });

  final failureNoElement = Failure(error: 'No element');

  test(
      'get Event by id when id equals -1 should return Failure',
          () async {
        // 'On the fly' eventRepository implementation using Mocito Library
        when(mockEventRepository.searchEventById(-1))
            .thenAnswer((_) async => Left(failureNoElement));
        // act
        // call not-yet existent method
        final result = await useCase(GetEventByIdParams(id: -1));
        // useCase simply return whatever is in repository
        expect(result, Left(failureNoElement));
        // verify is method has been called in eventRepository
        verify(mockEventRepository.searchEventById(-1));
        // check if only above method has been called and nothing more
        verifyNoMoreInteractions(mockEventRepository);
      });
}
