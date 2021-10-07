import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/platform/connection_type.dart';
import 'package:ironman/core/platform/internet_cubit.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:ironman/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/business/interactors/search_events_by_query.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/hive/abstraction/event_hive.dart';
import 'package:ironman/features/event/framework/presentation/bloc/event_bloc.dart';
import 'package:ironman/features/event/framework/presentation/bloc/event_event.dart';
import 'package:ironman/features/event/framework/presentation/bloc/event_state.dart';
import 'package:ironman/features/event/framework/presentation/widgets/bottom_loader.dart';
import 'package:ironman/features/event/framework/presentation/widgets/event_display_list_item.dart';
import 'package:ironman/features/event/framework/presentation/widgets/event_screen.dart';
import 'package:ironman/features/event/framework/presentation/widgets/filter_chip_widget.dart';
import 'package:ironman/features/event/framework/presentation/widgets/message_display.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/test_generator.dart';

class MockInternetBloc extends MockCubit<InternetState>
    implements InternetCubit {}

class InternetStateFake extends Fake implements InternetState {}

class MockEventBloc extends MockBloc<EventEvent, EventState>
    implements EventBloc {}

class EventStateFake extends Fake implements EventState {}

class EventEventFake extends Fake implements EventEvent {}

extension on WidgetTester {
  Future<void> pumpEventScreen(
      MockEventBloc mockEventBloc, MockInternetBloc mockInternetBloc) {
    return pumpWidget(BlocProvider(
        create: (context) => mockInternetBloc,
        child: MaterialApp(
          home: MultiBlocProvider(providers: [
            BlocProvider<InternetCubit>(create: (context) => mockInternetBloc),
            BlocProvider<EventBloc>(create: (context) => mockEventBloc),
          ], child: EventScreen()),
        )));
  }
}

void main() {
  MockEventBloc mockEventBloc;
  MockInternetBloc mockInternetBloc;
  List<Event> mockEvents;

  setUpAll(() {
    registerFallbackValue<EventState>(EventStateFake());
    registerFallbackValue<EventEvent>(EventEventFake());
    registerFallbackValue<InternetState>(InternetStateFake());
  });

  setUp(() {
    mockEventBloc = MockEventBloc();
    mockInternetBloc = MockInternetBloc();

    when(() => mockInternetBloc.state)
        .thenReturn(InternetConnected(ConnectionType.Wifi));

    mockEvents = getEvents(10);
  });

  tearDown(() {
    mockEventBloc?.close();
    mockInternetBloc?.close();
  });

  group('EventsList', () {
    testWidgets(
        'renders CircularProgressIndicator'
        'when event status is Loading', (tester) async {
      when(() => mockEventBloc.state).thenReturn(Loading());

      await tester.pumpEventScreen(mockEventBloc, mockInternetBloc);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'render empty list widget'
        'when events list is empty', (tester) async {
      when(() => mockEventBloc.state)
          .thenReturn(Loaded(events: [], isExhausted: true));

      await tester.pumpEventScreen(mockEventBloc, mockInternetBloc);

      expect(find.byType(MessageDisplay), findsOneWidget);
      expect(find.text(EVENTS_NOT_FOUND_MESSAGE_TEXT), findsOneWidget);
    });

    testWidgets(
        'render list with bottomLoader'
        'when list has 10 length and is not exhausted', (tester) async {
      when(() => mockEventBloc.state).thenAnswer(
          (invocation) => Loaded(events: mockEvents, isExhausted: false));
      await tester.pumpEventScreen(mockEventBloc, mockInternetBloc);
      final gesture =
          await tester.startGesture(Offset(0, 0)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -500)); //How much to scroll by
      await tester.pump(Duration.zero);
      expect(
          find.byType(EventListItem, skipOffstage: false), findsNWidgets(10));
      expect(find.byKey(Key(CUSTOM_SCROLL_VIEW_KEY)), findsOneWidget);
      expect(find.byType(BottomLoader, skipOffstage: false), findsOneWidget);
    });

    testWidgets(
        'render list without bottomLoader'
        'when list query is exhausted', (tester) async {
      // mock state
      when(() => mockEventBloc.state)
          .thenAnswer((_) => Loaded(events: mockEvents, isExhausted: true));

      // find finder
      final itemFinder = find.byType(EventListItem, skipOffstage: false);

      // build & render widget
      await tester.pumpEventScreen(mockEventBloc, mockInternetBloc);

      final gesture =
          await tester.startGesture(Offset(0, 0)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -500)); //How much to scroll by
      await tester.pump(Duration.zero);
      expect(itemFinder, findsNWidgets(10));
      expect(find.byType(BottomLoader), findsNothing);
    });

    testWidgets('fetch more events when scrolled to the bottom',
        (tester) async {
      when(() => mockEventBloc.state)
          .thenReturn(Loaded(events: getEvents(10), isExhausted: false));

      await tester.pumpEventScreen(mockEventBloc, mockInternetBloc);
      final gesture =
          await tester.startGesture(Offset(0, 0)); //Position of the scrollview
      await gesture.moveBy(Offset(0, -500)); //How much to scroll by
      await tester.pump();
      verify(() => mockEventBloc.add(SearchNextPageResultEvent())).called(1);
    });
  });

  group('Events chips', () {
    Future<void> _verifyChipsClicked(
        String orderAndFilter, String chipsLabel, WidgetTester tester) async {
      // build & render widget
      await tester.pumpEventScreen(mockEventBloc, mockInternetBloc);

      // find finder
      var allChipsFinder = find.widgetWithText(FilterChipWidget, chipsLabel);
      expect(allChipsFinder, findsOneWidget);

      // tap chips
      await tester.tap(allChipsFinder);
      // widget.pump
      await tester.pump(Duration.zero);
      // expect
      verify(() => mockEventBloc
          .add(UpdateOrderAndFilter(orderAndFilter: orderAndFilter))).called(1);
    }

    testWidgets('updateFilterAndOrder when upcoming chips is tapped',
        (tester) async {
      // mock cubit/bloc
      when(() => mockEventBloc.state).thenAnswer(
          (invocation) => Loaded(events: getEvents(10), isExhausted: false));

      _verifyChipsClicked(EVENT_FILTER_FUTURE_DATE, 'UPCOMING', tester);
    });

    testWidgets('updateFilterAndOrder when all chips is tapped',
        (tester) async {
      // mock cubit/bloc
      // can't be default value for orderAndFilter field
      when(() => mockEventBloc.state).thenAnswer((invocation) => Loaded(
          events: getEvents(10),
          isExhausted: false,
          orderAndFilter: EVENT_FILTER_FUTURE_DATE));

      _verifyChipsClicked(EVENT_FILTER_QUERY, 'ALL', tester);
    });

    testWidgets('updateFilterAndOrder when all chips is tapped',
        (tester) async {
      // mock cubit/bloc
      // can't be default value for orderAndFilter field
      when(() => mockEventBloc.state).thenAnswer(
          (invocation) => Loaded(events: getEvents(10), isExhausted: false));

      _verifyChipsClicked(EVENT_FILTER_PAST_DATE, 'PAST', tester);
    });
  });

  // search Box

  group('searchBox group', () {
    testWidgets('check if searchBox display correct value',
        (WidgetTester tester) async {
      // mock
      when(() => mockEventBloc.state).thenAnswer(
          (invocation) => Loaded(events: getEvents(10), isExhausted: false));

      // build & render Widget
      await tester.pumpEventScreen(mockEventBloc, mockInternetBloc);

      // find finder
      var textFieldFinder = find.byType(TextField);

      await tester.tap(textFieldFinder);
      await tester.enterText(textFieldFinder, 'poland');
      await tester.pump(Duration.zero);

      textFieldFinder = find.text('poland');
      expect(textFieldFinder, findsOneWidget);

      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump(Duration.zero);

      verify(() => mockEventBloc.add(SearchNewQuery(query: 'poland'))).called(1);
    });
  });
}
