import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ironman/core/data/generic_response.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/features/event/framework/datasource/network/abstraction/event_api_service.dart';
import 'package:ironman/features/event/framework/datasource/network/model/models.dart';
import 'package:ironman/features/event/framework/datasource/network/utils/Constants.dart';

class EventApiServiceImpl extends EventApiService {
  final http.Client client;

  EventApiServiceImpl(this.client);

  @override
  Future<EventDetailDto> getEventById(int id) async {
    final endpoint = '/v1/events';
    final uri = Uri.https(BASE_URL, '$endpoint/$id');

    final response = await client.get(uri,
        headers: {'Content-Type': 'application/json', 'apikey': API_KEY});

    final responseModel = GenericResponse.fromJson(json.decode(response.body));

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

    final uri = Uri.https(BASE_URL, SEARCH_EVENTS_BY_QUERY_ENDPOINT, queryParams);

    final response = await client.get(uri, headers: {
      CONTENT_TYPE_HEADER_KEY: CONTENT_TYPE_HEADER_VALUE,
      API_KEY: API_KEY_VALUE
    });

    final responseModel = GenericResponse.fromJson(json.decode(response.body));

    if (responseModel.status == 'fail') {

      throw ServerExceptions(
          message:
          'Error code: ${response.statusCode} \n ${responseModel.message}');
    }

    if (responseModel.data == null || responseModel.data.isEmpty) {
      return [];
    }

    List<EventDto> eventsDto = GenericResponse.mapDtoFromJson(responseModel.data);

    return eventsDto;
  }

  @override
  Future<List<EventDto>> searchUpcomingEventsByQuery(String query,
      int page, String dateTime) async {

    final queryParams = {
      QUERY_PARAM_NAME : query,
      PAGE_PARAM_NAME: page.toString(),
      START_DATE_PARAM: dateTime
    };

    final uri = Uri.https(BASE_URL,'/v1/search/events', queryParams);

    print('Uri: $uri');

    final response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'apikey': API_KEY
    });


    final responseModel = GenericResponse.fromJson(json.decode(response.body));


    if (responseModel.status == 'fail') {

      throw ServerExceptions(
          message:
          'Error code: ${response.statusCode} \n ${responseModel.message}');
    }

    if (responseModel.data == null || responseModel.data.isEmpty) {
      return [];
    }

    List<EventDto> eventsDto = GenericResponse.mapDtoFromJson(responseModel.data);

    return eventsDto;
  }

}

