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

    return EventModel(
      eventId: json['event_id'],
      eventCountryName: json['event_country'],
      eventVenue: json['event_venue'],
      eventFinishDate: json['event_finish_date'],
      eventDate: json['event_date'],
      eventTitle: json['event_title'],
      eventFlag: json['event_flag'],
    );
  }
}