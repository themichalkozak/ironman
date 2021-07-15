import 'dart:io';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/error/exceptions.dart';
import '../../../../../../lib/core/data/response_model.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:ironman/features/event/data/event/EventDetailModel.dart';
import 'package:ironman/features/event/data/event/EventModel.dart';
import 'package:ironman/features/event/data/event/event_remote_data_source.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import 'package:mockito/mockito.dart';

import '../../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  EventRemoteDataSourceImpl dataSourceImpl;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSourceImpl = EventRemoteDataSourceImpl(mockHttpClient);
  });

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Somth goes wrong', 404));
  }

  group('getEvents by query', () {
    Uri setUpMockHttpClientSuccessResponse(
        String queryParam, String jsonPath, String endpoint, int page) {
      final queryParams = {'query': queryParam, 'page': page.toString()};

      final uri = Uri.https(BASE_URL, endpoint, queryParams);
      when(mockHttpClient.get(uri,
              headers: {'Content-Type': 'application/json', 'apikey': API_KEY}))
          .thenAnswer((_) async => http.Response(fixture(jsonPath), 200));

      return uri;
    }

    final page = 1;
    final queryParam = 'poland';
    final failedQueryParam = '-123=*';
    final jsonPath = 'event/get_events_PL.json';
    final endpoint = '/v1/search/events';
    final eventTenseParam = EventTense.All;

    final tEventModel1 = EventModel(
        eventId: 122987,
        eventTitle: "1992 POL Duathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");

    final tEventModel2 = EventModel(
        eventId: 122986,
        eventTitle: "1992 POL Middle Distance Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");
    final tEventModel3 = EventModel(
        eventId: 122985,
        eventTitle: "1992 POL Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");

    List<EventModel> tEventModels = [tEventModel1, tEventModel2, tEventModel3];

    test('getEvents by query when apikey is correct called get request',
        () async {
      // arrange

      final uri = setUpMockHttpClientSuccessResponse(
          queryParam, jsonPath, endpoint, page);
      // act
      await dataSourceImpl.searchEventsByQuery(
          queryParam, eventTenseParam, page);
      // assert
      verify(mockHttpClient.get(uri,
          headers: {'Content-Type': 'application/json', 'apikey': API_KEY}));
    });

    final tResponse = ResponseModel(
        status: "success", currentPage: 1, lastPage: 15, data: tEventModels);

    test(
        'getEvents by query when apikey is correct return valid response model',
        () async {
      // arrange
      setUpMockHttpClientSuccessResponse(queryParam, jsonPath, endpoint, page);
      // act
      final result = await dataSourceImpl.searchEventsByQuery(
          queryParam, eventTenseParam, page);

      // assert
      expect(result, equals(tResponse.data));
    });

    test('getEvents by query when response is empty throw NoElementException',
        () async {
      // arrange
      setUpMockHttpClientSuccessResponse(failedQueryParam,
          'event/get_events_by_query_no_element.json', endpoint, page);
      // act
      final call = dataSourceImpl.searchEventsByQuery(
          failedQueryParam, eventTenseParam, page);

      // assert
      expect(() => call, throwsA(isA<NoElementExceptions>()));
    });

    test(
        'getEvents by query when responseCode is 404 or other throw ServerException',
        () async {
      // arrange
      setUpMockHttpClientFailure404();

      final call =
          dataSourceImpl.searchEventsByQuery(queryParam, eventTenseParam, page);

      // assert
      expect(() => call, throwsA(isA<ServerExceptions>()));
    });

    test(
        'getEvents by query when timeout doesn\'t occured return valid response model',
        () async {
      // arrange
      setUpMockHttpClientSuccessResponse(queryParam, jsonPath, endpoint, page);

      // act
      final result = await dataSourceImpl.searchEventsByQuery(
          queryParam, EventTense.All, page);

      // assert
      expect(result, equals(tResponse.data));
    });

    // Trzeba sprawdzić czy dataSourceImpl po 7s wyrzuca wyjątek timeout exception
    // Wywołać metodę mockHttpClient get
    // odpalić delaya na 7s
    // sprawdzić czy dataSourceImpl wyrzuca wyjątek

    test('getEvents by query when timeout is occured throw timeout', () async {

      final query = 'poland';
      final eventTense = EventTense.All;
      setUpMockHttpClientSuccessResponse(queryParam, jsonPath, endpoint, page);

      final call = await dataSourceImpl.searchEventsByQuery(query, eventTense, page);
      await Future.delayed(Duration(seconds: 7,microseconds: 10),(){});

      expect(() => call,throwsA(isA<TimeoutException>()));

    });
  });

  // ******************** get Events By Id **************************** //

  group('getEventById', () {
    // arrange
    final id = 149007;
    final endpoint = '/v1/events';
    final uri = Uri.https(BASE_URL, '$endpoint/$id');

    test('getEventById when apiKey is correct called get request', () async {
      when(mockHttpClient.get(uri, headers: {
        'Content-Type': 'application/json',
        'apikey': API_KEY
      })).thenAnswer((_) async =>
          http.Response(fixture('event/get_event_by_id_response.json'), 200));

      // act
      await dataSourceImpl.getEventById(id);

      // assert
      verify(mockHttpClient.get(uri,
          headers: {'Content-Type': 'application/json', 'apikey': API_KEY}));
    });

    test('getEventById when is correct apikey return valid EventModel',
        () async {
      // arrange
      final testListEventSpec = [
        EventSpecificationModel(name: 'Triathlon', id: 357, parentId: null),
        EventSpecificationModel(name: 'Relay', id: 379, parentId: 357)
      ];

      final testEventDetail = EventDetailModel(
          eventId: 149007,
          eventTitle:
              '1985 Ulster ETU Triathlon Team Relay European Championships',
          eventDate: "1985-06-08",
          eventFinishDate: "1985-06-08",
          eventVenue: 'Ulster',
          eventCountryName: 'Ireland',
          eventFlag: 'https://triathlon-images.imgix.net/images/icons/ie.png',
          eventSpecifications: testListEventSpec,
          eventWebSite: null,
          information: null);

      when(mockHttpClient.get(uri, headers: {
        'Content-Type': 'application/json',
        'apikey': API_KEY
      })).thenAnswer((_) async =>
          http.Response(fixture('event/get_event_by_id_response.json'), 200));
      // act
      final result = await dataSourceImpl.getEventById(id);

      // assert
      expect(result, equals(testEventDetail));
    });

    test('getEventById when statusCode is not 200 throw ServerException', () {
      // arrange
      when(mockHttpClient.get(uri,
              headers: {'Content-Type': 'application/json', 'apikey': API_KEY}))
          .thenThrow(ServerExceptions(message: SERVER_FAILURE_MESSAGE));

      // act
      final call = dataSourceImpl.getEventById(id);

      // assert

      expect(() => call, throwsA(isA<ServerExceptions>()));
    });
  });
}
