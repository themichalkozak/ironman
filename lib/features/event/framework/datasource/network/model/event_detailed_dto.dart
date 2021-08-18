import 'package:flutter/foundation.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';

class EventDetailDto extends EventDetail {
  final int eventId;

  final String eventTitle;

  final String eventDate;

  final String eventFinishDate;

  final String eventVenue;

  final String eventCountryName;

  final String eventFlag;

  final List<EventSpecificationDto> eventSpecifications;

  final String eventWebSite;

  final String information;

  EventDetailDto({
    this.eventId,
    this.eventTitle,
    this.eventDate,
    this.eventFinishDate,
    this.eventVenue,
    this.eventCountryName,
    this.eventFlag,
    this.eventSpecifications,
    this.eventWebSite,
    this.information,
  });

  factory EventDetailDto.fromJson(Map<String, dynamic> json) {
    List<EventSpecificationDto> eventSpecificationModels = [];

    (json['event_specifications'] as List)?.forEach((json) {
      eventSpecificationModels.add(EventSpecificationDto.fromJson(json));
    });

    return EventDetailDto(
        eventId: json['event_id'],
        eventTitle: json['event_title'],
        eventDate: json['event_date'],
        eventFinishDate: json['event_finish_date'],
        eventVenue: json['event_venue'],
        eventCountryName: json['event_country'],
        eventFlag: json['event_flag'],
        eventSpecifications: eventSpecificationModels,
        eventWebSite: json['eventId'] ?? '',
        information: json['eventId']) ??
        'No information';
  }
}

class EventSpecificationDto extends EventSpecification {

  final String name;
  final int id;
  final int parentId;

  EventSpecificationDto({
    @required this.name,
    @required this.id,
    @required this.parentId,
  }) : super(name, id, parentId);

  factory EventSpecificationDto.fromJson(Map<String, dynamic> json) {
    return EventSpecificationDto(
        name: json['cat_name'],
        id: json['cat_id'],
        parentId: json['cat_parent_id']);
  }
}
