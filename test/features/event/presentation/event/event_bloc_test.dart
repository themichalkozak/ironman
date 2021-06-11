import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import 'package:ironman/features/event/domain/useCases/get_events.dart';
import 'package:ironman/features/event/domain/useCases/search_events_by_query.dart';
import 'package:ironman/features/event/presentation/bloc/event_bloc.dart';
import 'package:ironman/features/event/presentation/bloc/event_event.dart';
import 'package:ironman/features/event/presentation/bloc/event_state.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

// ignore: must_be_immutable
class MockGetEvents extends Mock implements GetEvents {}

class MockSearchEventsByQuery extends Mock implements SearchEventsByQuery {}

void main() {
  EventBloc bloc;
  MockGetEvents mockGetEvents;
  MockSearchEventsByQuery mockSearchEventsByQuery;

  setUp(() {
    mockGetEvents = MockGetEvents();
    mockSearchEventsByQuery = MockSearchEventsByQuery();
    bloc = EventBloc(
        getEvents: mockGetEvents,
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
              getEvents: null, searchEventsByQuery: null),
      throwsA(isAssertionError),
    );
  });

  group('get Events', () {
    Event eventModel1 = Event(
        eventId: 149007,
        eventTitle:
        '1985 Ulster ETU Triathlon Team Relay European Championships',
        eventDate: '1985-06-08',
        eventFinishDate: '1985-06-08',
        eventVenue: 'Ulster',
        eventCountryName: 'Ireland',
        eventFlag: 'https://triathlon-images.imgix.net/images/icons/ie.png');

    Event eventModel2 = Event(
        eventId: 140860,
        eventTitle: '1985 Immenstadt ETU Triathlon European Championships',
        eventDate: '1985-07-27',
        eventFinishDate: '1985-07-27',
        eventVenue: 'Immenstadt',
        eventCountryName: 'Germany',
        eventFlag: 'https://triathlon-images.imgix.net/images/icons/de.png');

    Event eventModel3 = Event(
        eventId: 140949,
        eventTitle:
        '1985 Almere ETU Long Distance Triathlon European Championships',
        eventDate: '1985-08-17',
        eventFinishDate: '1985-08-17',
        eventVenue: 'Almere',
        eventCountryName: 'Netherlands',
        eventFlag: 'https://triathlon-images.imgix.net/images/icons/nl.png');

    List<Event> tEventModels = [eventModel1, eventModel2, eventModel3];

    blocTest(
        'getEvents when response is success return [Loading(),Loaded(tEventModels)]',
        build: () {
          when(mockGetEvents(any)).thenAnswer((_) async => Right(tEventModels));
          return bloc;
        },
        act: (bloc) => bloc.add(GetEventsEvent(eventTense: EventTense.All)),
        expect: () => [Loading(), Loaded(events: tEventModels)]);

    blocTest(
        'getEvents when respose is serverFailure return [Loading(),Error(serverFailure)_]',
        build: () {
          when(mockGetEvents(any))
              .thenAnswer((_) async => Left(ServerFailure()));
          return bloc;
        },
        act: (bloc) => bloc.add(GetEventsEvent(eventTense: EventTense.All)),
        expect: () => [Loading(), Error(errorMessage: SERVER_FAILURE_MESSAGE)]);

    blocTest(
        'getEvents when response is NoElement return [Loading(),Error(noElement)]',
        build: () {
          when(mockGetEvents(any)).thenAnswer((_) async =>
              Left(NoElementFailure(error: NO_ELEMENT_FAILURE_MESSAGE)));
          return bloc;
        },
        act: (bloc) => bloc.add(GetEventsEvent(eventTense: EventTense.All)),
        expect: () =>
        [Loading(), Error(errorMessage: NO_ELEMENT_FAILURE_MESSAGE)]);
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
        expect: () => [Loading(), Loaded(events: tEvents)]);

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
