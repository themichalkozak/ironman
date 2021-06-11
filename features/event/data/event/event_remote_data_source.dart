import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ironman/features/event/domain/event_tense.dart';
import 'package:ironman/features/event/presentation/bloc/bloc.dart';
import '../../../../core/utils/constants.dart';
import 'package:ironman/core/error/exceptions.dart';
import '../../../../core/listing_response_model.dart';
import 'EventDetailModel.dart';
import 'EventModel.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getEvents(EventTense eventTense);

  Future<List<EventModel>> searchEventsByQuery(
      String query, EventTense eventTense);

  Future<EventDetailModel> getEventById(int id);
}

class EventRemoteDataSourceImpl extends EventRemoteDataSource {
  final http.Client client;

  EventRemoteDataSourceImpl(this.client);

  @override
  Future<List<EventModel>> getEvents(EventTense eventTense) async {

    final uri = Uri.https(BASE_URL, '/v1/events');

    final response = await client.get(uri,
        headers: {'Content-Type': 'application/json', 'apikey': API_KEY});

    if (response.statusCode != 200) {
      throw ServerExceptions(message: 'Error');
    }
    final responseModel = ListingResponseModel.fromJson(json.decode(response.body));

    if (responseModel.status == 'fail') {
      throw ServerExceptions(message: responseModel.message);
    }

    List<EventModel> events = [];

    if (responseModel.data == null) {
      throw NoElementExceptions(message: responseModel.message);
    }

    responseModel.data.forEach((element) {
      events.add(EventModel.fromJson(element));
    });

    return events;
  }

  @override
  Future<EventDetailModel> getEventById(int id) async {

    final endpoint = '/v1/events';
    final uri = Uri.https(BASE_URL,'$endpoint/$id');

    final response = await client.get(uri,
        headers:  {'Content-Type': 'application/json',
          'apikey': API_KEY});

    if(response.statusCode != 200){
      throw ServerExceptions(message: SERVER_FAILURE_MESSAGE);
    }

    final jsonMap = json.decode(response.body);

    return EventDetailModel.fromJson(jsonMap);
  }

  @override
  Future<List<EventModel>> searchEventsByQuery( String query, EventTense eventTense) async {

    final queryParams = {'query': query};

    final uri = Uri.https(BASE_URL, '/v1/search/events', queryParams);

    final response = await client.get(uri,
        headers: {'Content-Type': 'application/json', 'apikey': API_KEY});

    if(response.statusCode != 200){
      throw ServerExceptions(message: response.statusCode.toString());
    }

    final responseModel = ListingResponseModel.fromJson(json.decode(response.body));


    if(responseModel.status == 'fail'){
      throw ServerExceptions(message: responseModel.message);
    }
    if(responseModel.data == null || responseModel.data.isEmpty){
      throw NoElementExceptions(message: 'No elements');
    }

    List<EventModel> events = [];

    responseModel.data.forEach((element) {
      events.add(EventModel.fromJson(element));
    });

    return events;

  }


}
