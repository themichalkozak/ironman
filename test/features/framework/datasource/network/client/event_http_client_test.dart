import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:ironman/core/data/generic_response.dart';

import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/features/event/business/domain/utils/date_util.dart';
import 'package:ironman/features/event/framework/datasource/network/client/abstraction/event_http_client.dart';
import 'package:ironman/features/event/framework/datasource/network/client/implementation/event_http_client_impl.dart';
import 'package:ironman/features/event/framework/datasource/network/model/models.dart';
import 'package:ironman/features/event/framework/datasource/network/utils/Constants.dart';
import 'package:mockito/mockito.dart';

import '../../../../../fixtures/fixture_reader.dart';
import '../utils/http_mock_helper_method.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  EventHttpClient eventHttpClient;
  MockHttpClient mockHttpClient;
  DateUtils dateUtils;

  setUp(() {
    mockHttpClient = MockHttpClient();
    eventHttpClient = EventHttpClientImpl(mockHttpClient, dateUtils);
  });

  Uri setUpMockHttpClientSuccessDelayedResponse(
      String jsonPath, String endpoint, http.Client mockHttpClient,
      [Map<String, dynamic> queryParams]) {
    Uri uri;

    if (queryParams != null) {
      uri = Uri.https(BASE_URL, endpoint, queryParams);
    } else {
      uri = Uri.https(BASE_URL, endpoint);
    }

    when(mockHttpClient.get(uri, headers: {
      'Content-Type': 'application/json',
      'apikey': API_KEY_VALUE
    })).thenAnswer((_) async => Future.delayed(
        Duration(seconds: 8), () => http.Response(fixture(jsonPath), 200)));

    return uri;
  }

  group('getEvents by query', () {
    final page = 1;
    final queryParam = 'poland';
    final jsonPath = 'event/get_events_PL.json';
    final failedJsonPath = 'event/get_events_fail.json';
    final endpoint = '/v1/search/events';

    final queryParams = {'query': queryParam, 'page': page.toString()};

    final tEventModel1 = EventDto(
        eventId: 122987,
        eventTitle: "1992 POL Duathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");

    final tEventModel2 = EventDto(
        eventId: 122986,
        eventTitle: "1992 POL Middle Distance Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");
    final tEventModel3 = EventDto(
        eventId: 122985,
        eventTitle: "1992 POL Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png");

    List<EventDto> tEventModels = [tEventModel1, tEventModel2, tEventModel3];

    test('getEvents by query when apikey is correct called get request',
        () async {
      // arrange

      final uri = setUpMockHttpClientSuccessResponse(
          jsonPath, endpoint, mockHttpClient, queryParams);
      // act
      await eventHttpClient.searchEventsByQuery(queryParam, page);
      // assert
      verify(mockHttpClient.get(uri, headers: {
        'Content-Type': 'application/json',
        'apikey': API_KEY_VALUE
      }));
    });

    final tResponse = GenericResponse(
        status: "success", currentPage: 1, lastPage: 15, data: tEventModels);

    test(
        'getEvents by query when apikey is correct return valid response model',
        () async {
      // arrange
      setUpMockHttpClientSuccessResponse(
          jsonPath, endpoint, mockHttpClient, queryParams);
      // act
      final result =
          await eventHttpClient.searchEventsByQuery(queryParam, page);

      // assert
      expect(result, equals(tResponse.data));
    });

    test(
        'getEvents by query when responseCode is 404 or other throw ServerException',
        () async {
      // arrange
      setUpMockHttpClientFailure404(failedJsonPath, mockHttpClient);

      final call = eventHttpClient.searchEventsByQuery(queryParam, page);

      // assert
      expect(() => call, throwsA(isA<ServerExceptions>()));
    });

    test('get events by query when timeout is occurred', () {
      setUpMockHttpClientSuccessDelayedResponse(
          jsonPath, endpoint, mockHttpClient, queryParams);

      final call = eventHttpClient.searchEventsByQuery(queryParam, page);

      expect(() => call, throwsA(isA<TimeoutException>()));
    });
  });

  // ******************** get Events By Id **************************** //

  group('getEventById', () {
    // arrange
    final id = 149007;
    final endpoint = '/v1/events/$id';
    final jsonPath = 'event/get_event_by_id_response.json';

    test('getEventById when apiKey is correct called get request', () async {
      final uri = setUpMockHttpClientSuccessResponse(
          jsonPath, endpoint, mockHttpClient);

      // act
      await eventHttpClient.getEventById(id);

      // assert
      verify(mockHttpClient.get(uri, headers: {
        'Content-Type': 'application/json',
        'apikey': API_KEY_VALUE
      }));
    });

    final testListEventSpec = [
      EventSpecificationDto(name: 'Triathlon', id: 357, parentId: null),
      EventSpecificationDto(name: 'Relay', id: 379, parentId: 357)
    ];

    final testEventDetail = EventDetailDto(
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

    test('getEventById when is correct apikey return valid EventModel',
        () async {
      // arrange
      setUpMockHttpClientSuccessResponse(jsonPath, endpoint, mockHttpClient);
      // act
      final result = await eventHttpClient.getEventById(id);

      // assert
      expect(result, equals(testEventDetail));
    });

    test('getEventById when statusCode is not 200 throw ServerException', () {
      // arrange

      setUpMockHttpClientException(jsonPath, mockHttpClient);

      // act
      final call = eventHttpClient.getEventById(id);

      // assert

      expect(() => call, throwsA(isA<ServerExceptions>()));
    });

    test('get event by id when timeout is occurred', () async {
      setUpMockHttpClientSuccessDelayedResponse(
          jsonPath, endpoint, mockHttpClient);

      final call = eventHttpClient.getEventById(id);

      expect(() => call, throwsA(isA<TimeoutException>()));
    });
  });

  // ---------------------- UPCOMING EVENTS -------------------------

  group('search upcoming events by query', () {
    final String jsonPath = 'event/get_upcoming_events_by_query.json';
    final String failedJsonPath = 'event/get_events_fail.json';
    final endpoint = '/v1/search/events';

    final queryParam = '';
    final String startDateParam = '2021-08-07';
    final page = 1;

    final queryParams = {
      QUERY_PARAM_NAME: queryParam,
      PAGE_PARAM_NAME: page.toString(),
      START_DATE_PARAM: startDateParam,
      ORDER_PARAM_NAME: ORDER_ASC_PARAM
    };

    test(
        'search upcoming events by query when apikey is correct called get request',
        () async {
      // arrange

      Uri uri = setUpMockHttpClientSuccessResponse(
          jsonPath, endpoint, mockHttpClient, queryParams);

      // Uri uri  = Uri.https(BASE_URL, endpoint,queryParams);
      //
      // when(mockHttpClient.get(uri,  headers: {'Content-Type': 'application/json', 'apikey': API_KEY_VALUE}))
      // .thenAnswer((realInvocation) async => http.Response(fixture(jsonPath), 200));

      // act
      await eventHttpClient.searchUpcomingEventsByQuery(
          queryParam, page, startDateParam);

      // assert
      verify(mockHttpClient.get(uri, headers: {
        'Content-Type': 'application/json',
        'apikey': API_KEY_VALUE
      }));
    });

    final tUpcomingEvent = EventDto(
        eventId: 154373,
        eventTitle: "2021 Europe Triathlon Junior Cup Riga",
        eventVenue: "Riga",
        eventCountryName: "Latvia",
        eventDate: "2021-08-08",
        eventFinishDate: "2021-08-08",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/lv.png");

    final tUpcomingEvent2 = EventDto(
        eventId: 153772,
        eventTitle:
            "Groupe Copley 2021 World Triathlon Championship Series Montreal",
        eventVenue: "Montreal",
        eventCountryName: "Canada",
        eventDate: "2021-08-13",
        eventFinishDate: "2021-08-15",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/ca.png");

    final tUpcomingEvent3 = EventDto(
        eventId: 154883,
        eventTitle: "2021 Europe Triathlon Junior Cup Izvorani",
        eventVenue: "Izvorani",
        eventCountryName: "Romania",
        eventDate: "2021-08-14",
        eventFinishDate: "2021-08-15",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/ro.png");

    List<EventDto> tUpcomingEvents = [
      tUpcomingEvent,
      tUpcomingEvent2,
      tUpcomingEvent3
    ];

    GenericResponse tUpcomingResponseModel = GenericResponse(
        status: 'success', data: tUpcomingEvents, currentPage: 1, lastPage: 99);

    test(
        'search upcoming events by query when api call is correct return valid response model',
        () async {
      // arrange

      setUpMockHttpClientSuccessResponse(
          jsonPath, endpoint, mockHttpClient, queryParams);

      // act
      final result = await eventHttpClient.searchUpcomingEventsByQuery(
          queryParam, page, startDateParam);

      expect(result, tUpcomingResponseModel.data);
    });

    test(
        'search upcoming events by query when data is null or status is fail throw Server Exception',
        () async {
      // arrange
      setUpMockHttpClientFailure404(failedJsonPath, mockHttpClient);

      // act
      final call = eventHttpClient.searchUpcomingEventsByQuery(
          queryParam, page, startDateParam);

      // assert
      expect(() => call, throwsA(isA<ServerExceptions>()));
    });

    test('search upcoming events by query when timeout is occurred', () {
      setUpMockHttpClientSuccessDelayedResponse(
          jsonPath, endpoint, mockHttpClient,queryParams);

      final call = eventHttpClient.searchUpcomingEventsByQuery(
          queryParam, page, startDateParam);

      expect(() => call, throwsA(isA<TimeoutException>()));
    });
  });
}
