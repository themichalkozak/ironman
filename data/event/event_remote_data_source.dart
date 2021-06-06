import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ironman/core/constants.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/data/ResponseModel.dart';

import 'package:ironman/data/event/EventDetailModel.dart';
import 'package:ironman/data/event/EventModel.dart';
import 'package:ironman/domain/event/event_tense.dart';

abstract class EventRemoteDataSource {
  Future<List<EventModel>> getEvents(EventTense eventTense);

  Future<List<EventModel>> searchEventsByQuery(String query,
      EventTense eventTense);

  Future<EventDetailModel> getEventById(int id);
}

class EventRemoteDataSourceImpl extends EventRemoteDataSource {
  final http.Client client;

  EventRemoteDataSourceImpl(this.client);

  @override
  Future<List<EventModel>> getEvents(EventTense eventTense) async {
    final response = await client.get(BASE_URL + '/events',
        headers: {'Content-Type': 'application/json', 'apikey': API_KEY});

    if (response.statusCode != 200) {
      throw ServerExceptions(message: 'Error');
    }
    final responseModel = ResponseModel.fromJson(json.decode(response.body));

    if (responseModel.status == 'fail') {
      throw ServerExceptions(message: responseModel.message);
    }

    List<EventModel> events = [];

    if(responseModel.data == null){
      throw NoElementFailure();
    }

    responseModel.data.forEach((element) {
      events.add(EventModel.fromJson(element));
    });

    return events;
  }

  @override
  Future<EventDetailModel> getEventById(int id) {}

  @override
  Future<List<EventModel>> searchEventsByQuery(String query,
      EventTense eventTense) {
//
  }
}
