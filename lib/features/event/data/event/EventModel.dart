import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/features/event/domain/entity/event.dart';

part 'EventModel.g.dart';

@HiveType(typeId: 1)

class EventModel extends Event {


  @override
  @HiveField(0)
  final int eventId;
  @override
  @HiveField(1)
  final String eventTitle;
  @override
  @HiveField(2)
  final String eventDate;
  @override
  @HiveField(3)
  final String eventFinishDate;
  @override
  @HiveField(4)
  final String eventVenue;
  @override
  @HiveField(5)
  final String eventCountryName;
  @HiveField(6)
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