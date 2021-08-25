// ignore: must_be_immutable
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/error/failure.dart';
import '../../../../../lib/features/event/business/domain/models/event_detailed_model.dart';
import 'package:ironman/features/event/domain/useCases/get_event_by_id.dart';
import 'package:ironman/features/event/presentation/bloc/detail/bloc.dart';
import 'package:mockito/mockito.dart';

class MockGetEventById extends Mock implements GetEventById {}


void main() {
  EventDetailBloc bloc;
  MockGetEventById mockGetEventById;

  setUp(() {
    mockGetEventById = MockGetEventById();
    bloc = EventDetailBloc(
        getEventById: mockGetEventById);
    });

  tearDown(() {
    bloc?.close();
  });

  test('initial state should be empty', () async {
    await expectLater(bloc.initialState, Empty());
  });

  test('should assert if null', () {
    expect(
          () =>
          EventDetailBloc(
              getEventById: null),
      throwsA(isAssertionError),
    );
  });

  group('getEvenById', () {

    final testListEventSpec = [EventSpecificationModel(name: 'Triathlon',id: 357, parentId: null),EventSpecificationModel(name: 'Relay',id: 379, parentId: 357)];

    final testEventDetail = EventDetailModel(
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



    blocTest('getEventById where id is 149007 emit [Loading(),LoadedDetail(testEventDetail)]',
    build: () {
      when(mockGetEventById(GetEventByIdParams(id: testEventDetail.eventId)))
          .thenAnswer((_) async => Right(testEventDetail));
      return bloc;
    },
    act: (bloc) => bloc.add(GetEventByIdEvent(id: testEventDetail.eventId)),
    expect: () => [Loading(),Loaded(data: testEventDetail)]);

  blocTest('getEventById where is serverFailure emit[Loading(),Error()]',
      build: () {
        when(mockGetEventById(any))
            .thenAnswer((_) async => Left(NetworkFailure()));
        return bloc;
      },
      act: (bloc) => bloc.add(GetEventByIdEvent(id: 0)),
      expect: () => [Loading(),Error(errorMessage: SERVER_FAILURE_MESSAGE)]);

  });

}