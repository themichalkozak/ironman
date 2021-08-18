import 'dart:convert';

import 'package:dartz/dartz_unsafe.dart';
import 'package:http/http.dart' as http;
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/utils/date_format.dart';
import '../../../../core/data/generic_response.dart';
import '../../../../core/utils/constants.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'event_detailed_model.dart';
import 'EventModel.dart';

abstract class EventRemoteDataSource {
  Future<List<EventDto>> searchEventsByQuery(String query, int page);

  Future<EventDetailModel> getEventById(int id);

  Future<List<EventDto>> searchUpcomingEventsByQuery(String query, int page, String dateTime);
}

class EventRemoteDataSourceImpl extends EventRemoteDataSource {
  final http.Client client;

  EventRemoteDataSourceImpl(this.client);

  @override
  Future<EventDetailModel> getEventById(int id) async {
    final endpoint = '/v1/events';
    final uri = Uri.https(BASE_URL, '$endpoint/$id');

    final response = await client.get(uri,
        headers: {'Content-Type': 'application/json', 'apikey': API_KEY})
        .timeout(Duration(seconds: 7), onTimeout: () {
      throw TimeoutException(message: TIMEOUT_FAILURE_MESSAGE);
    });

    final responseModel = GenericResponse.fromJson(json.decode(response.body));

    if (responseModel.status == 'fail') {
      throw ServerExceptions(message: responseModel.message);
    }

    return EventDetailModel.fromJson(responseModel.data);
  }

  @override
  Future<List<EventDto>> searchEventsByQuery(String query, int page) async {

    final queryParams = {'query': query, 'page': page.toString()};

    List<EventDto> events = [];

    final uri = Uri.https(BASE_URL, '/v1/search/events', queryParams);

    print('Uri" $uri');

    final response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'apikey': API_KEY
    }).timeout(Duration(seconds: 7), onTimeout: () {
      throw TimeoutException(message: TIMEOUT_FAILURE_MESSAGE);
    });

    final responseModel = GenericResponse.fromJson(json.decode(response.body));

    if (responseModel.status == 'fail') {
      print(
          'event_remote_data_source | searchEventsByQuery | message: ${responseModel
              .message}');
      throw ServerExceptions(
          message:
          'Error code: ${response.statusCode} \n ${responseModel.message}');
    }

    if (responseModel.data == null || responseModel.data.isEmpty) {
      return events;
    }

    responseModel.data.forEach((element) {
      events.add(EventDto.fromJson(element));
    });

    print(
        'event_remote_data_source | searchEventsByQuery | events size: ${events
            .length}');

    return events;
  }

  @override
  Future<List<EventDto>> searchUpcomingEventsByQuery(String query,
      int page, String dateTime) async {

    final queryParams = {
      'query': query,
      'page': page.toString(),
      'start_date': dateTime
    };

    final uri = Uri.https(BASE_URL,'/v1/search/events', queryParams);

    print('Uri: $uri');

    final response = await client.get(uri, headers: {
      'Content-Type': 'application/json',
      'apikey': API_KEY
    }).timeout(Duration(seconds: 7), onTimeout: () {
      throw TimeoutException(message: TIMEOUT_FAILURE_MESSAGE);
    });


  final responseModel = GenericResponse.fromJson(json.decode(response.body));

    List<EventDto> events = [];

    if (responseModel.status == 'fail') {
      print(
          'event_remote_data_source | searchEventsByQuery | message: ${responseModel
              .message}');
      throw ServerExceptions(
          message:
          'Error code: ${response.statusCode} \n ${responseModel.message}');
    }

    if (responseModel.data == null || responseModel.data.isEmpty) {
      return events;
    }

    responseModel.data.forEach((element) {
      events.add(EventDto.fromJson(element));
    });

    return events;
  }

}

