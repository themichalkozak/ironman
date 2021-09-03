import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/error/failure.dart';
import '../../../../../lib/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import 'package:ironman/features/event/domain/useCases/search_events_by_query.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

// ignore: must_be_immutable

class MockSearchEventsByQuery extends Mock implements SearchEventsByQuery {}

void main() {
  EventBloc bloc;
  MockSearchEventsByQuery mockSearchEventsByQuery;

  setUp(() {
    mockSearchEventsByQuery = MockSearchEventsByQuery();
    bloc = EventBloc(searchEvents: mockSearchEventsByQuery);
  });

  tearDown(() {
    bloc?.close();
  });

  test('initial state should be empty', () async {
    await expectLater(bloc.initialState, Empty());
  });

  test('should assert if null', () {
    expect(
      () => EventBloc(searchEvents: null),
      throwsA(isAssertionError),
    );
  });

  group('getEvents by query', () {
    final String query = 'poland';

    final tEventModelPast1 = Event(
        eventId: 122987,
        eventTitle: "1992 POL Duathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");

    final tEventModelPast2 = Event(
        eventId: 122986,
        eventTitle: "1992 POL Middle Distance Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");

    final tEventModelPast3 = Event(
        eventId: 122985,
        eventTitle: "1992 POL Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");

    final tEventModelUpcoming1 = Event(
        eventId: 122985,
        eventTitle: "1992 POL Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "2031-08-30",
        eventFinishDate: "2021-08-30",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");

    final tEventModelUpcoming2 = Event(
        eventId: 122985,
        eventTitle: "1992 POL Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "2032-08-30",
        eventFinishDate: "2022-08-30",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");

    List<Event> tEvents = [
      tEventModelPast1,
      tEventModelPast2,
      tEventModelPast3,
      tEventModelUpcoming1,
      tEventModelUpcoming2
    ];

    List<Event> tPastEvents = [
      tEventModelPast1,
      tEventModelPast2,
      tEventModelPast3
    ];

    List<Event> tUpCommingEvents = [tEventModelUpcoming1, tEventModelUpcoming2];

    List<Either<Failure,List<Event>>> list = [Right(tEvents)];

    final queryParam = 'poland';

    // helper methods

    void mockSuccessSearchQueryEvents() {
      when(mockSearchEventsByQuery(
              SearchEventsByQueryParams(page: 1, query: 'poland')))
          .thenAnswer((_) => Stream.fromIterable(list));
    }

    blocTest(
        'getEvents by query where query param is poland return [Loading(),Loaded(tEvents)]',
        build: () {
          // mockSuccessSearchQueryEvents();
          when(mockSearchEventsByQuery.call(
              SearchEventsByQueryParams(page: 1, query: 'poland')))
              .thenAnswer((_) => Stream.fromIterable(list));
          return bloc;
        },
        act: (bloc) {
          bloc.add(SearchNewQuery(query: queryParam));
          verify(mockSearchEventsByQuery.call(SearchEventsByQueryParams(page: 1,query: 'poland')));
          return bloc;
        },
        // isExhausted is true b/c list is less PER_PAGE = 10;
        expect: () => [
              Loading(),
              Loaded(
                  events: tEvents,
                  isExhausted: false,
                  orderAndFilter: String.All)
            ]
    );

    blocTest(
        'get Events by query where event tense is past return events before today',
        build: () {
          mockSuccessSearchQueryEvents();
          bloc.add(SearchNewQuery(query: query));
          return bloc;
        },
        act: (bloc) => {
              bloc.add(FilterByEventTenseEvent(eventTense: String.Past)),
            },
        skip: 2,
        expect: () => [
              Loading(),
              Loaded(
                  events: tPastEvents,
                  isExhausted: false,
                  orderAndFilter: String.Past)
            ]);

    blocTest(
        'get events by query when event tense is upcoming return events after today',
        build: () {
          mockSuccessSearchQueryEvents();
          bloc.add(SearchNewQuery(query: queryParam));
          return bloc;
        },
        act: (bloc) => {
              bloc.add(FilterByEventTenseEvent(eventTense: String.Upcoming)),
            },
        skip: 2,
        expect: () => [
              Loading(),
              Loaded(
                  events: tUpCommingEvents,
                  isExhausted: tUpCommingEvents.isEmpty,
                  orderAndFilter: String.Upcoming)
            ]);

    blocTest(
        'getEvents by query where is ServerFailure emit [Loading(),Error()]',
        build: () {
          when(mockSearchEventsByQuery(any)).thenAnswer((_) async* {
            yield Left(NetworkFailure());
          });
          return bloc;
        },
        act: (bloc) => bloc.add(SearchNewQuery(query: ''),
            expect: () =>
                [Loading(), Error(errorMessage: SERVER_FAILURE_MESSAGE)]));

    blocTest('should reset filtering when is new searchQuery',
        build: () {
          mockSuccessSearchQueryEvents();
          bloc.add(SearchNewQuery(query: query));
          bloc.add(FilterByEventTenseEvent(eventTense: String.Past));
          return bloc;
        },
        skip: 4,
        act: (bloc) => {bloc.add(SearchNewQuery(query: query))},
        expect: () => [
              Loading(),
              Loaded(
                  events: tEvents,
                  orderAndFilter: String.All,
                  isExhausted: tEvents.isEmpty)
            ]);
  });
}
