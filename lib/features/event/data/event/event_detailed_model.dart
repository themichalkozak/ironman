import 'package:flutter/foundation.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'event_detailed_model.g.dart';

@HiveType(typeId: 2)
class EventDetailModel extends EventDetail {

  @HiveField(0)
  final int eventId;

  @HiveField(1)
  final String eventTitle;

  @HiveField(2)
  final String eventDate;

  @HiveField(3)
  final String eventFinishDate;

  @HiveField(4)
  final String eventVenue;

  @HiveField(5)
  final String eventCountryName;

  @HiveField(6)
  final String eventFlag;

  @HiveField(7)
  final List<EventSpecificationModel> eventSpecifications;

  @HiveField(8)
  final String eventWebSite;

  @HiveField(9)
  final String information;


  EventDetailModel({
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
