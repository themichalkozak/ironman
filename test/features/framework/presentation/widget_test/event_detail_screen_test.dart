import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import 'package:ironman/features/event/framework/presentation/bloc/detail/bloc.dart';
import 'package:ironman/features/event/framework/presentation/screens/event_detail_screen.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/test_generator.dart';

/// 1) Mock EventDetailBloc
/// 2) Mock EventDetailState
/// 3  Mock EventDetailEvent
///
class MockEventDetailBloc extends MockBloc<EventDetailEvent, EventDetailState>
    implements EventDetailBloc {}

class FakeEventDetailState extends Fake implements EventDetailState {}

class FakeEventDetailEvent extends Fake implements EventDetailEvent {}

void main() {
  MockEventDetailBloc mockEventDetailBloc;

  setUpAll(() {
    registerFallbackValue<EventDetailState>(EventDetailState());
    registerFallbackValue<EventDetailEvent>(EventDetailEvent());
  });

  setUp(() {
    mockEventDetailBloc = MockEventDetailBloc();
  });

  group('loading widget', () {
    testWidgets('should render CircularProgressIndicator',
        (WidgetTester tester) async {
      when(() => mockEventDetailBloc.state)
          .thenAnswer((invocation) => Loading());

      await tester.pumpEventDetailScreen(mockEventDetailBloc);

      var progressIndicatorFinder = find.byType(CircularProgressIndicator);

      expect(progressIndicatorFinder, findsOneWidget);
    });
  });

  group('event detail list', () {
    testWidgets('should render messageDisplay with error message',
        (WidgetTester tester) async {
      // Mock

      when(() => mockEventDetailBloc.state).thenAnswer(
          (invocation) => Error(errorMessage: EVENTS_NOT_FOUND_MESSAGE_TEXT));

      // Build & Render Widget
      await tester.pumpEventDetailScreen(mockEventDetailBloc);

      // find
      var textFinder = find.text(EVENTS_NOT_FOUND_MESSAGE_TEXT);

      // expect
      expect(textFinder, findsOneWidget);
    });

    testWidgets('should render Event Detail Display when is Loaded state',
        (WidgetTester tester) async {
      // mock
      EventDetail tEventDetail = getTestEventDetail();
      when(() => mockEventDetailBloc.state)
          .thenAnswer((invocation) => Loaded(data: tEventDetail));

      // build and render widget
      await tester.pumpEventDetailScreen(mockEventDetailBloc);

      await tester.pump(Duration.zero);

      // find
      var titleTextFinder = find.text(tEventDetail.eventTitle);

      // expect
      expect(titleTextFinder, findsOneWidget);

      var dateTextFinder = find.text(tEventDetail.eventDate);
      expect(dateTextFinder, findsOneWidget);

      // country
      var countryNameFinder = find.text(tEventDetail.eventCountryName);

      expect(countryNameFinder, findsOneWidget);
      // venue

      var venueNameFinder = find.text(tEventDetail.eventVenue);
      expect(venueNameFinder, findsOneWidget);

      // Event Information Header

      var informationHeaderFinder = find.text('Event Information:');
      expect(informationHeaderFinder, findsOneWidget);

      // Events Information Description
      // Co w przypadku, gdy jest nullem
      var informationDescriptionFinder = find.text('No information');
      expect(informationDescriptionFinder, findsOneWidget);

      // Category Header
      var categoryHeaderFinder =
          find.byKey(Key(CATEGORY_HEADER_KEY), skipOffstage: false);
      expect(categoryHeaderFinder, findsOneWidget);

      // Category List

      tEventDetail.eventSpecifications.forEach((element) {
        var elementFinder = find.text(element.name, skipOffstage: false);
        expect(elementFinder, findsOneWidget);
      });
    });
  });
}

extension on WidgetTester {
  Future<void> pumpEventDetailScreen(MockEventDetailBloc mockEventDetailBloc) {
    return pumpWidget(BlocProvider<EventDetailBloc>(
      create: (context) => mockEventDetailBloc,
      child: MaterialApp(
        home: EventDetailScreen(),
      ),
    ));
  }
}
