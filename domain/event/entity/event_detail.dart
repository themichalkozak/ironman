import 'package:flutter/foundation.dart';
import 'package:ironman/domain/event/entity/event.dart';

class EventDetail extends Event {
  final List<EventSpecification> eventSpecifications;
  final String eventWebSite;
  final String information;

  EventDetail({
    @required int eventId,
    @required String eventTitle,
    @required String eventDate,
    @required String eventFinishDate,
    @required String eventVenue,
    @required String eventCountryName,
    @required String eventFlag,
    @required this.eventSpecifications,
    @required this.eventWebSite,
    @required this.information,
  }) : super(
            eventId: eventId,
            eventTitle: eventTitle,
            eventDate: eventDate,
            eventFinishDate: eventFinishDate,
            eventVenue: eventVenue,
            eventCountryName: eventCountryName,
            eventFlag: eventCountryName);
}

class EventSpecification {
  final String name;
  final int id;
  final int parentId;

  EventSpecification(this.name, this.id, this.parentId);
}
