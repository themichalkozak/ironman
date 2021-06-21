import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import 'package:ironman/features/event/domain/useCases/search_events_by_query.dart';
import 'package:ironman/features/event/presentation/bloc/event_bloc.dart';
import 'package:ironman/features/event/presentation/bloc/event_event.dart';
import 'package:ironman/features/event/presentation/bloc/event_state.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

// ignore: must_be_immutable

class MockSearchEventsByQuery extends Mock implements SearchEventsByQuery {}

void main() {
  EventBloc bloc;
  MockSearchEventsByQuery mockSearchEventsByQuery;

  setUp(() {
    mockSearchEventsByQuery = MockSearchEventsByQuery();
    bloc = EventBloc(
        searchEventsByQuery: mockSearchEventsByQuery);
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
          EventBloc(
              searchEventsByQuery: null),
      throwsA(isAssertionError),
    );
  });

  group('getEvents by query', () {
    final tEventModel1 = Event(
        eventId: 122987,
        eventTitle: "1992 POL Duathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");

    final tEventModel2 = Event(
        eventId: 122986,
        eventTitle: "1992 POL Middle Distance Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");
    final tEventModel3 = Event(
        eventId: 122985,
        eventTitle: "1992 POL Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");

    List<Event> tEvents = [tEventModel1, tEventModel2, tEventModel3];

    final queryParam = 'poland';
    blocTest(
        'getEvents by query where query param is poland return [Loading(),Loaded(tEvents)]',
        build: () {
          when(mockSearchEventsByQuery(SearchEventsByQueryParams(
              query: 'poland', eventTense: EventTense.All)))
              .thenAnswer((_) async => Right(tEvents));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(SearchEventsByQueryEvent(
                query: queryParam, eventTense: EventTense.All)),
        // isExhauseted is true b/c list is less PER_PAGE = 10;
        expect: () => [Loading(), Loaded(events: tEvents,isExhausted: true)]);

    blocTest(
        'getEvents by query where is ServerFailure emit [Loading(),Error()]',
        build: () {
          when(mockSearchEventsByQuery(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          return bloc;
        },
        act: (bloc) =>
            bloc.add(
                SearchEventsByQueryEvent(
                    query: '', eventTense: EventTense.All)),
        expect: () => [Loading(), Error(errorMessage: SERVER_FAILURE_MESSAGE)]);
  });

}
