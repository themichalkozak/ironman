import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/business/interactors/get_event_by_id.dart';
import 'package:ironman/features/event/framework/presentation/bloc/detail/event_detail_bloc.dart';
import 'package:ironman/features/event/framework/presentation/bloc/detail/event_detail_event.dart';
import 'package:ironman/features/event/framework/presentation/bloc/detail/event_detail_state.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/test_generator.dart';

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
    await expectLater(bloc.initialState, Initial());
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

    final tEventDetail = getTestEventDetail();

    blocTest('getEventById where id is 0 emit [Loading(),LoadedDetail(testEventDetail)]',
        build: () {
          when(mockGetEventById(GetEventByIdParams(id: tEventDetail.eventId)))
              .thenAnswer((_) => Stream.value(Right(tEventDetail)));
          return bloc;
        },
        act: (bloc) => bloc.add(GetEventByIdEvent(id: tEventDetail.eventId)),
        expect: () => [Loading(),Loaded(data: tEventDetail)]);


    blocTest('getEventById where is serverFailure emit[Loading(),Error()]',
        build: () {
          when(mockGetEventById(any))
              .thenAnswer((_) => Stream.value(Left(NetworkFailure())));
          return bloc;
        },
        act: (bloc) => bloc.add(GetEventByIdEvent(id: 0)),
        expect: () => [Loading(),Error(errorMessage: SERVER_FAILURE_MESSAGE)]);

  });

}