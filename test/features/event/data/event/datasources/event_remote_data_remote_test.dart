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

  group('get Events', () {
    Uri setUpMockHttpClientSuccessResponse(String jsonPath, String endpoint) {
      final uri = Uri.https(BASE_URL, endpoint);

      when(mockHttpClient.get(uri,
              headers: {'Content-Type': 'application/json', 'apikey': API_KEY}))
          .thenAnswer((_) async => http.Response(fixture(jsonPath), 200));

      return uri;
    }

    test('get Events where is correct apikey should perform get request',
        () async {
      // arrange
      // mock response for EventRemoteDataSourceImpl

      final jsonPath = 'event/get_events_3_per_page_ordered_by_asc.json';
      final endpoint = '/v1/events';
      final uri = setUpMockHttpClientSuccessResponse(jsonPath, endpoint);

      // act
      // send get request to API
      await dataSourceImpl.getEvents(EventTense.All, 1);
      // assert
      // check if this method was called

      verify(mockHttpClient.get(uri,
          headers: {'Content-Type': 'application/json', 'apikey': API_KEY}));
    });

    EventModel eventModel1 = EventModel(
        eventId: 149007,
        eventTitle:
            '1985 Ulster ETU Triathlon Team Relay European Championships',
        eventDate: '1985-06-08',
        eventFinishDate: '1985-06-08',
        eventVenue: 'Ulster',
        eventCountryName: 'Ireland',
        eventFlag: 'https://triathlon-images.imgix.net/images/icons/ie.png');

    EventModel eventModel2 = EventModel(
        eventId: 140860,
        eventTitle: '1985 Immenstadt ETU Triathlon European Championships',
        eventDate: '1985-07-27',
        eventFinishDate: '1985-07-27',
        eventVenue: 'Immenstadt',
        eventCountryName: 'Germany',
        eventFlag: 'https://triathlon-images.imgix.net/images/icons/de.png');

    EventModel eventModel3 = EventModel(
        eventId: 140949,
        eventTitle:
            '1985 Almere ETU Long Distance Triathlon European Championships',
        eventDate: '1985-08-17',
        eventFinishDate: '1985-08-17',
        eventVenue: 'Almere',
        eventCountryName: 'Netherlands',
        eventFlag: 'https://triathlon-images.imgix.net/images/icons/nl.png');

    List<EventModel> eventModels = [eventModel1, eventModel2, eventModel3];

    test('get Events when apikey is correct return List of EventModel',
        () async {
      // arrange
      final String jsonPath = 'event/get_events_3_per_page_ordered_by_asc.json';
      final endpoint = '/v1/events';
      setUpMockHttpClientSuccessResponse(jsonPath, endpoint);

      // act
      final result = await dataSourceImpl.getEvents(EventTense.All, 1);

      // assert
      expect(result, equals(eventModels));
    });

    test('get Events when error is 404 response code or other', () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = dataSourceImpl.getEvents;
      // assert
      expect(() => call(EventTense.All, 1), throwsA(isA<ServerExceptions>()));
    });

    EventModel eventModel4 = EventModel(
        eventId: 140885,
        eventTitle:
            '1985 Abenra ETU Middle Distance Triathlon European Championships',
        eventDate: '1985-09-01',
        eventFinishDate: '1985-09-01',
        eventVenue: 'Aabenraa',
        eventCountryName: 'Denmark',
        eventFlag: 'https://triathlon-images.imgix.net/images/icons/dk.png');

    EventModel eventModel5 = EventModel(
        eventId: 149058,
        eventTitle:
            '1986 Mansfield ETU Triathlon Team Relay European Championships',
        eventDate: '1986-01-01',
        eventFinishDate: '1986-01-01',
        eventVenue: 'Mansfield',
        eventCountryName: 'Great Britain',
        eventFlag: 'https://triathlon-images.imgix.net/images/icons/gb.png');

    EventModel eventModel6 = EventModel(
        eventId: 140919,
        eventTitle:
            '1986 Brasschaat ETU Middle Distance Triathlon European Championships',
        eventDate: '1986-06-21',
        eventFinishDate: '1986-06-21',
        eventVenue: 'Brasschaat',
        eventCountryName: 'Belgium',
        eventFlag: 'https://triathlon-images.imgix.net/images/icons/be.png');

    List<EventModel> eventModels2 = [eventModel4, eventModel5, eventModel6];

    test(
        'getEvents when page is 2 and per page is 3 return Events from next page',
        () async {
      // arrange
      final int page = 2;
      final queryParams = {'page': page.toString()};
      final jsonPath = 'event/get_events_page_2.json';
      final uri = Uri.https(BASE_URL, '/v1/events', queryParams);

      when(mockHttpClient.get(uri,
              headers: {'Content-Type': 'application/json', 'apikey': API_KEY}))
          .thenAnswer((_) async => http.Response(fixture(jsonPath), 200));
      final result = await dataSourceImpl.getEvents(EventTense.All, 2);
      // assert
      expect(result, eventModels2);
    });
  });

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
      await dataSourceImpl.searchEventsByQuery(queryParam, eventTenseParam, page);
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
          setUpMockHttpClientSuccessResponse(failedQueryParam, 'event/get_events_by_query_no_element.json', endpoint, page);
      // act
      final call =
          dataSourceImpl.searchEventsByQuery(failedQueryParam, eventTenseParam, page);

      // assert
      expect(() => call, throwsA(isA<NoElementExceptions>()));
    });

    test(
        'getEvents by query when responseCode is 404 or other throw ServerException',
        () async {
      // arrange
      setUpMockHttpClientFailure404();

      final call = dataSourceImpl.searchEventsByQuery(queryParam, eventTenseParam,page);

      // assert
      expect(() => call, throwsA(isA<ServerExceptions>()));
    });
  });

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
