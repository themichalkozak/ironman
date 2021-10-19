import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ironman/core/data/generic_response.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/business/domain/utils/date_util.dart';
import 'package:ironman/features/event/framework/datasource/network/utils/network_error.dart';
import '../../../cache/event/hive/abstraction/event_hive.dart';
import '../abstraction/event_http_client.dart';
import 'package:ironman/features/event/framework/datasource/network/model/models.dart';
import 'package:ironman/features/event/framework/datasource/network/utils/Constants.dart';

class EventHttpClientImpl extends EventHttpClient {
  final http.Client client;
  DateUtils dateUtils;

  EventHttpClientImpl(this.client, this.dateUtils);

  @override
  Future<EventDetailDto> getEventById(int id) async {
    final endpoint = '/v1/events';
    final uri = Uri.https(BASE_URL, '$endpoint/$id');

    final response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'apikey': API_KEY_VALUE
    }).timeout(Duration(seconds: 3), onTimeout: () {
      throw TimeoutException(message: TIMEOUT_FAILURE_MESSAGE);
    });

    final responseModel = GenericResponse.fromJson(json.decode(response.body));

    print('event_api_service | getEventById | responseModel: ${response.body}');

    if (responseModel.status == 'fail') {
      throw ServerExceptions(message: responseModel.message);
    }

    return EventDetailDto.fromJson(responseModel.data);
  }

  @override
  Future<List<EventDto>> searchEventsByQuery(String query, int page) async {
    final queryParams = {
      QUERY_PARAM_NAME: query,
      PAGE_PARAM_NAME: page.toString()
    };

    final uri =
        Uri.https(BASE_URL, SEARCH_EVENTS_BY_QUERY_ENDPOINT, queryParams);

    final response = await client.get(uri, headers: {
      CONTENT_TYPE_HEADER_KEY: CONTENT_TYPE_HEADER_VALUE,
      API_KEY: API_KEY_VALUE
    }).timeout(Duration(seconds: 3), onTimeout: () {
      throw TimeoutException(message: TIMEOUT_FAILURE_MESSAGE);
    });

    final responseModel = GenericResponse.fromJson(json.decode(response.body));

    if (responseModel.status == 'fail') {
      throw ServerExceptions(
          message:
              'Error code: ${response.statusCode} \n ${responseModel.message}');
    }

    if (responseModel.data == null || responseModel.data.isEmpty) {
      return null;
    }

    List<EventDto> eventsDto =
        GenericResponse.mapDtoFromJson(responseModel.data);

    return eventsDto;
  }

  @override
  Future<List<EventDto>> searchUpcomingEventsByQuery(
      String query, int page, String dateTime) async {
    final queryParams = {
      QUERY_PARAM_NAME: query,
      PAGE_PARAM_NAME: page.toString(),
      START_DATE_PARAM: dateTime,
      ORDER_PARAM_NAME: ORDER_ASC_PARAM
    };

    final uri = Uri.https(BASE_URL, '/v1/search/events', queryParams);

    print('Uri: $uri');

    final response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'apikey': API_KEY_VALUE
    }).timeout(Duration(seconds: 3), onTimeout: () {
      throw TimeoutException(message: NETWORK_TIMEOUT_ERROR);
    });

    print('event_http_client_impl | response: ${response.statusCode}');

    final responseModel = GenericResponse.fromJson(json.decode(response.body));

    if (responseModel.status == 'fail') {
      throw ServerExceptions(
          message:
              'Error code: ${response.statusCode} \n ${responseModel.message}');
    }

    if (responseModel.data == null || responseModel.data.isEmpty) {
      return null;
    }

    List<EventDto> eventsDto =
        GenericResponse.mapDtoFromJson(responseModel.data);

    print('event_api_service_impl | eventsDto: $eventsDto');

    return eventsDto;
  }

  @override
  Future<List<EventDto>> searchPastEvents(
      String query, int page, String dateTime) async {
    final queryParams = {
      QUERY_PARAM_NAME: query,
      PAGE_PARAM_NAME: page.toString(),
      START_DATE_PARAM: dateTime,
      ORDER_PARAM_NAME: ORDER_DESC_PARAM
    };

    final uri = Uri.https(BASE_URL, '/v1/search/events', queryParams);

    print('Uri: $uri');

    final response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'apikey': API_KEY_VALUE
    }).timeout(Duration(seconds: 3), onTimeout: () {
      throw TimeoutException(message: NETWORK_TIMEOUT_ERROR);
    });

    final responseModel = GenericResponse.fromJson(json.decode(response.body));

    if (responseModel.status == 'fail') {
      throw ServerExceptions(
          message:
              'Error code: ${response.statusCode} \n ${responseModel.message}');
    }

    if (responseModel.data == null || responseModel.data.isEmpty) {
      return null;
    }

    List<EventDto> eventsDto =
        GenericResponse.mapDtoFromJson(responseModel.data);

    return eventsDto;
  }

  @override
  Future<List<EventDto>> searchFilteredEvents(
      String query, int page, String filterAndOrder,
      [DateTime dateTime]) {
    if (dateTime == null) {
      dateTime = DateTime.now();
    }

    String formattedDateTime = dateUtils.startDateToString(dateTime);

    switch (filterAndOrder) {
      case ORDER_BY_DATE_ASC:
        {
          return searchEventsByQuery(query, page);
        }
      // https://api.triathlon.org/v1/events?order=desc&start_date=2021-07-08
      case ORDER_BY_DESC_PAST_DATE:
        {
          return searchPastEvents(query, page, formattedDateTime);
        }
      case ORDER_BY_ASC_FUTURE_DATE:
        {
          return searchUpcomingEventsByQuery(query, page, formattedDateTime);
        }
      default:
        {
          return searchEventsByQuery(query, page);
        }
    }
  }
}
