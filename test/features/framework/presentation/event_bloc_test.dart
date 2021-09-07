import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/business/interactors/search_events_by_query.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/hive/abstraction/event_hive.dart';
import 'package:ironman/features/event/framework/presentation/bloc/event_bloc.dart';
import 'package:ironman/features/event/framework/presentation/bloc/event_event.dart';
import 'package:ironman/features/event/framework/presentation/bloc/event_state.dart';
import 'package:mockito/mockito.dart';

import '../../../fixtures/test_generator.dart';

class MockSearchEventsByQuery extends Mock implements SearchEventsByQuery {}

void main() {
  EventBloc bloc;
  MockSearchEventsByQuery mockSearchEventsByQuery;

  setUp(() {
    mockSearchEventsByQuery = MockSearchEventsByQuery();
    bloc = EventBloc(searchEventsByQuery: mockSearchEventsByQuery);
  });

  tearDown(() {
    bloc?.close();
  });

  test('initial state should be empty', () async {
    await expectLater(bloc.initialState, Initial());
  });

  test('should assert if null', () {
    expect(
      () => EventBloc(searchEventsByQuery: null),
      throwsA(isAssertionError),
    );
  });

  group('getEvents by query', () {


    Iterable<Either<Failure, List<Event>>> tIterable1Page = [
      Right(getEvents(10))
    ];
    Iterable<Either<Failure, List<Event>>> tIterable2Page = [
      Right(getEvents(16, 10))
    ];
    List<Event> page1List = getEvents(10);
    List<Event> page2List = getEvents(16, 10);

    final queryParam = 'poland';

    // helper methods

    void mockSuccessSearchQueryEvents() {
      when(mockSearchEventsByQuery(SearchEventsByQueryParams(
              page: 1, query: 'poland', filterAndOrder: ORDER_BY_DATE_ASC)))
          .thenAnswer((_) => Stream.fromIterable(tIterable1Page));
    }

    blocTest(
        'getEvents by query where query param is poland return [Loading(),Loaded(tEvents)]',
        build: () {
          mockSuccessSearchQueryEvents();
          return bloc;
        },
        act: (bloc) {
          bloc.add(SearchNewQuery(query: queryParam));
          verify(mockSearchEventsByQuery.call(SearchEventsByQueryParams(
              page: 1, query: 'poland', filterAndOrder: ORDER_BY_DATE_ASC)));
          return bloc;
        },
        // isExhausted is true b/c list is less PER_PAGE = 10;
        expect: () => [
              Loading(),
              Loaded(
                  events: page1List,
                  isExhausted: false,
                  orderAndFilter: ORDER_BY_DATE_ASC)
            ]);


    blocTest(
        'search next page result return [Loading(),Loaded(prevList + newList)]',
        build: () {
          when(mockSearchEventsByQuery(SearchEventsByQueryParams(
                  page: 1, query: 'poland', filterAndOrder: ORDER_BY_DATE_ASC)))
              .thenAnswer((_) => Stream.fromIterable(tIterable1Page));

          when(mockSearchEventsByQuery(SearchEventsByQueryParams(
                  page: 2, query: 'poland', filterAndOrder: ORDER_BY_DATE_ASC)))
              .thenAnswer((_) => Stream.fromIterable(tIterable2Page));
          return bloc;
        },
        act: (bloc) {
          bloc
            ..add(SearchNewQuery(
                query: 'poland', orderAndFilter: ORDER_BY_DATE_ASC))
            ..add(SearchNextPageResultEvent());
          return bloc;
        },
        skip: 2,
        // isExhausted is true b/c list is less PER_PAGE = 10;
        expect: () => [
              Loaded(
                  events: page1List + page2List,
                  isExhausted: true,
                  orderAndFilter: ORDER_BY_DATE_ASC)
            ]);

    blocTest('update order and filter return new event list',
        build: () {
          when(mockSearchEventsByQuery(SearchEventsByQueryParams(
                  page: 1,
                  query: 'poland',
                  filterAndOrder: EVENT_FILTER_QUERY)))
              .thenAnswer((_) => Stream.fromIterable(tIterable1Page));

          when(mockSearchEventsByQuery(SearchEventsByQueryParams(
                  page: 1,
                  query: 'poland',
                  filterAndOrder: EVENT_FILTER_FUTURE_DATE)))
              .thenAnswer((_) => Stream.fromIterable(tIterable1Page));
          return bloc;
        },
        act: (bloc) {
          bloc
            ..add(SearchNewQuery(
                query: 'poland', orderAndFilter: EVENT_FILTER_QUERY))
            ..add(
                UpdateOrderAndFilter(orderAndFilter: EVENT_FILTER_FUTURE_DATE));
        },
        skip: 2,
        expect: () => [
              Loading(),
              Loaded(
                  events: page1List,
                  isExhausted: false,
                  orderAndFilter: EVENT_FILTER_FUTURE_DATE)
            ]);
  });
}
