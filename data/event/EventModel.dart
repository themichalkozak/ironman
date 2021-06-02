import 'package:flutter/foundation.dart';
import 'package:ironman/domain/event/entity/event.dart';

class EventModel extends Event {

  final int eventId;
  final String eventTitle;
  final String eventDate;
  final String eventFinishDate;
  final String eventVenue;
  final String eventCountryName;
  final String eventFlag;

  EventModel({
    @required this.eventId,
    @required this.eventTitle,
    @required this.eventDate,
    @required this.eventFinishDate,
    @required this.eventVenue,
    @required this.eventCountryName,
    @required this.eventFlag,
  });

  factory EventModel.fromJson(Map<String,dynamic> json){

    var eventModelJson = json['data'];

    return EventModel(
      eventId: eventModelJson['event_id'],
      eventCountryName: eventModelJson['event_country'],
      eventVenue: eventModelJson['event_venue'],
      eventFinishDate: eventModelJson['event_finish_date'],
      eventDate: eventModelJson['event_date'],
      eventTitle: eventModelJson['event_title'],
      eventFlag: eventModelJson['event_flag'],
    );
  }
}