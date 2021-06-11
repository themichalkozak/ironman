import 'package:flutter/foundation.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';

class EventDetailModel extends EventDetail {
  EventDetailModel({
    @required int eventId,
    @required String eventTitle,
    @required String eventDate,
    @required String eventFinishDate,
    @required String eventVenue,
    @required String eventCountryName,
    @required String eventFlag,
    @required List<EventSpecificationModel> eventSpecifications,
    @required String eventWebSite,
    @required String information,
  }) : super(
            eventId: eventId,
            eventTitle: eventTitle,
            eventDate: eventDate,
            eventFinishDate: eventFinishDate,
            eventVenue: eventVenue,
            eventCountryName: eventCountryName,
            eventFlag: eventFlag,
            eventSpecifications: eventSpecifications,
            eventWebSite: eventWebSite,
            information: information);

  factory EventDetailModel.fromJson(Map<String, dynamic> json) {

    List<EventSpecificationModel> eventSpecificationModels = [];

    (json['event_specifications'] as List)?.forEach((json) {
      eventSpecificationModels.add(EventSpecificationModel.fromJson(json));
    });

    return EventDetailModel(
        eventId: json['event_id'],
        eventTitle: json['event_title'],
        eventDate: json['event_date'],
        eventFinishDate: json['event_finish_date'],
        eventVenue: json['event_venue'],
        eventCountryName: json['event_country'],
        eventFlag: json['event_flag'],
        eventSpecifications: eventSpecificationModels,
        eventWebSite: json['eventId'] ?? '',
        information: json['eventId']) ?? 'No information';
  }
}

class EventSpecificationModel extends EventSpecification {
  EventSpecificationModel(
      {@required String name, @required int id, @required int parentId})
      : super(name, id, parentId);

  factory EventSpecificationModel.fromJson(Map<String, dynamic> json) {
    return EventSpecificationModel(
        name: json['cat_name'],
        id: json['cat_id'],
        parentId: json['cat_parent_id']);
  }
}
