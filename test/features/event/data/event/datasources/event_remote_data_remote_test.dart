import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/error/exceptions.dart';
import '../../../../../../lib/core/data/response_model.dart';
import 'package:ironman/core/utils/constants.dart';
import 'package:ironman/features/event/data/event/event_detailed_model.dart';
import 'package:ironman/features/event/data/event/EventModel.dart';
import 'package:ironman/features/event/data/event/event_remote_data_source.dart';
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

  Uri setUpMockHttpClientSuccessDelayedResponse2(
      Map<String,dynamic> queryParams, String jsonPath, String endpoint, int page) {

    final uri = Uri.https(BASE_URL, endpoint, queryParams);
    when(mockHttpClient.get(uri,
        headers: {'Content-Type': 'application/json', 'apikey': API_KEY}))
        .thenAnswer((_) async => Future.delayed(Duration(seconds: 8),() => http.Response(fixture(jsonPath), 200)));

    return uri;
  }

  Uri setUpMockHttpClientSuccessDelayedResponse(
      String queryParam, String jsonPath, String endpoint, int page) {
    final queryParams = {'query': queryParam, 'page': page.toString()};

    final uri = Uri.https(BASE_URL, endpoint, queryParams);
    when(mockHttpClient.get(uri,
        headers: {'Content-Type': 'application/json', 'apikey': API_KEY}))
        .thenAnswer((_) async => Future.delayed(Duration(seconds: 8),() => http.Response(fixture(jsonPath), 200)));

    return uri;
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
      await dataSourceImpl.searchEventsByQuery(queryParam, page);
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
      final result = await dataSourceImpl.searchEventsByQuery(queryParam, page);

      // assert
      expect(result, equals(tResponse.data));
    });

    test('getEvents by query when response is empty throw NoElementException',
        () async {
      // arrange
      setUpMockHttpClientSuccessResponse(failedQueryParam,
          'event/get_events_by_query_no_element.json', endpoint, page);
      // act
      final call = dataSourceImpl.searchEventsByQuery(failedQueryParam, page);

      // assert
      expect(() => call, throwsA(isA<NoElementExceptions>()));
    });

    test(
        'getEvents by query when responseCode is 404 or other throw ServerException',
        () async {
      // arrange
      setUpMockHttpClientFailure404();

      final call = dataSourceImpl.searchEventsByQuery(queryParam, page);

      // assert
      expect(() => call, throwsA(isA<ServerExceptions>()));
    });

    test(
        'getEvents by query when timeout doesn\'t occured return valid response model',
        () async {
      // arrange
      setUpMockHttpClientSuccessResponse(queryParam, jsonPath, endpoint, page);

      // act
      final result = await dataSourceImpl.searchEventsByQuery(queryParam, page);

      // assert
      expect(result, equals(tResponse.data));
    });

    // Trzeba sprawdzić czy dataSourceImpl po 7s wyrzuca wyjątek timeout exception
    // Wywołać metodę mockHttpClient get
    // odpalić delaya na 7s
    // sprawdzić czy dataSourceImpl wyrzuca wyjątek

    test('getEvents by query when timeout is occured throw timeout', () async {
      final query = 'poland';
      setUpMockHttpClientSuccessDelayedResponse(queryParam, jsonPath, endpoint, page);

      final call = dataSourceImpl.searchEventsByQuery(query, page);

      expect(() => call, throwsA(isA<TimeoutException>()));
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

  // ---------------------- UPCOMING EVENTS -------------------------

  group('search upcoming events by query', () {
    final String upcomingJsonPath = 'event/get_upcoming_events_by_query.json';
    final endpoint = '/v1/search/events';

    final queryParam = '';
    final String startDateParam = '2021-08-07';
    final page = 1;
    final int perPage = 3;

    final queryParams = {
      'query': queryParam,
      'start_date': startDateParam,
      'page': page.toString(),

    };

    Uri setUpMockHttpClientSuccessResponse(String queryParam, String jsonPath,
        String endpoint, int page, String startDate, int perPage) {
      final queryParams = {
        'query': queryParam,
        'page': page.toString(),
        'start_date': startDate,
      };

      final uri = Uri.https(BASE_URL, endpoint, queryParams);

      when(mockHttpClient.get(uri,
              headers: {'Content-Type': 'application/json', 'apikey': API_KEY}))
          .thenAnswer((_) async =>
              http.Response(fixture('event/get_upcoming_events_by_query.json'), 200));

      return uri;
    }

    Uri setUpMockHttpClientSuccessResponseDelayed(String queryParam, String jsonPath,
        String endpoint, int page, String startDate, int perPage) {
      final queryParams = {
        'query': queryParam,
        'page': page.toString(),
        'start_date': startDate,
      };

      final uri = Uri.https(BASE_URL, endpoint, queryParams);

      when(mockHttpClient.get(uri,
          headers: {'Content-Type': 'application/json', 'apikey': API_KEY}))
          .thenAnswer((_) async =>
          Future.delayed(Duration(seconds: 8),() => http.Response(fixture(jsonPath), 200)));

      return uri;
    }

    test(
        'search upcoming events by query when apikey is correct called get request',
        () async {
      // arrange


      Uri uri = setUpMockHttpClientSuccessResponse(queryParam, upcomingJsonPath,
          endpoint, page, startDateParam, perPage);

      // act
      await dataSourceImpl.searchUpcomingEventsByQuery(
          queryParam, page, startDateParam);

      // assert
      verify(mockHttpClient.get(uri,
          headers: {'Content-Type': 'application/json', 'apikey': API_KEY}));
    });

    final tUpcomingEvent = EventModel(
        eventId: 154373,
        eventTitle: "2021 Europe Triathlon Junior Cup Riga",
        eventVenue: "Riga",
        eventCountryName: "Latvia",
        eventDate: "2021-08-08",
        eventFinishDate: "2021-08-08",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/lv.png");

    final tUpcomingEvent2 = EventModel(
        eventId: 153772,
        eventTitle: "Groupe Copley 2021 World Triathlon Championship Series Montreal",
        eventVenue: "Montreal",
        eventCountryName: "Canada",
        eventDate: "2021-08-13",
        eventFinishDate: "2021-08-15",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/ca.png");

    final tUpcomingEvent3 = EventModel(
        eventId: 154883,
        eventTitle: "2021 Europe Triathlon Junior Cup Izvorani",
        eventVenue: "Izvorani",
        eventCountryName: "Romania",
        eventDate: "2021-08-14",
        eventFinishDate: "2021-08-15",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/ro.png");

    List<EventModel> tUpcomingEvents = [
      tUpcomingEvent,
      tUpcomingEvent2,
      tUpcomingEvent3
    ];

    ResponseModel tUpcomingResponseModel = ResponseModel(
        status: 'success', data: tUpcomingEvents, currentPage: 1, lastPage: 99);

    test(
        'search upcoming events by query when api call is correct return valid response model',
        () async {
      // arrange

      setUpMockHttpClientSuccessResponse(
          queryParam, upcomingJsonPath, endpoint, page, startDateParam, perPage);

      // act
      final result = await dataSourceImpl.searchUpcomingEventsByQuery(
          queryParam, page, startDateParam);

      expect(result, tUpcomingResponseModel.data);
    });

    test('search upcoming events by query when http timout occured throw Timeout exception',() async{

      // arrange
      setUpMockHttpClientSuccessResponseDelayed( queryParam, upcomingJsonPath, endpoint, page, startDateParam, perPage);

      // act
      final call = dataSourceImpl.searchUpcomingEventsByQuery(queryParam, page, startDateParam);

      // assert

      expect(() => call, throwsA(isA<TimeoutException>()));
    });
  });
}
