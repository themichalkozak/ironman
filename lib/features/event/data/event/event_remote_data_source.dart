import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../../../core/data/response_model.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import '../../../../core/utils/constants.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'EventDetailModel.dart';
import 'EventModel.dart';

abstract class EventRemoteDataSource {

  Future<List<EventModel>> searchEventsByQuery(
      String query, EventTense eventTense, int page);

  Future<EventDetailModel> getEventById(int id);
}

class EventRemoteDataSourceImpl extends EventRemoteDataSource {
  final http.Client client;

  EventRemoteDataSourceImpl(this.client);

  @override
  Future<EventDetailModel> getEventById(int id) async {
    final endpoint = '/v1/events';
    final uri = Uri.https(BASE_URL, '$endpoint/$id');

    final response = await client.get(uri,
        headers: {'Content-Type': 'application/json', 'apikey': API_KEY});

    final responseModel = ResponseModel.fromJson(json.decode(response.body));

    if (responseModel.status == 'fail') {
      throw ServerExceptions(message: responseModel.message);
    }

    return EventDetailModel.fromJson(responseModel.data);
  }

  @override
  Future<List<EventModel>> searchEventsByQuery(
      String query, EventTense eventTense, int page) async {
    final queryParams = {'query': query, 'page': page.toString()};

    List<EventModel> events = [];

    final uri = Uri.https(BASE_URL, '/v1/search/events', queryParams);

    print('Uri" $uri');

    final response = await client.get(uri,
        headers: {'Content-Type': 'application/json', 'apikey': API_KEY});

    if (response.statusCode != 200) {
      throw ServerExceptions(message: response.statusCode.toString());
    }

    final responseModel = ResponseModel.fromJson(json.decode(response.body));

    if (responseModel.status == 'fail') {
      throw ServerExceptions(message: responseModel.message);
    }
    if (responseModel.data == null || responseModel.data.isEmpty) {
      return events;
    }

    responseModel.data.forEach((element) {
      events.add(EventModel.fromJson(element));
    });

    return events;
  }
}
