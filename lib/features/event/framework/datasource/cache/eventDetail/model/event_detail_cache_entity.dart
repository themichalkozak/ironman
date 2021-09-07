import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/model/event_specification_cache_entity.dart';

part 'event_detail_cache_entity.g.dart';

@HiveType(typeId: 2)
class EventDetailCacheEntity extends HiveObject {
  @HiveField(0)
  HiveList<EventSpecificationCacheEntity> eventSpecifications;
  @HiveField(1)
  String eventWebSite;
  @HiveField(2)
  String information;
  @HiveField(3)
  int eventId;
  @HiveField(4)
  String eventTitle;
  @HiveField(5)
  String eventDate;
  @HiveField(6)
  String eventFinishDate;
  @HiveField(7)
  String eventVenue;
  @HiveField(8)
  String eventCountryName;
  @HiveField(9)
  String eventFlag;

  EventDetailCacheEntity(
      {this.eventSpecifications,
      this.eventWebSite,
      this.information,
      this.eventId,
      this.eventTitle,
      this.eventDate,
      this.eventFinishDate,
      this.eventVenue,
      this.eventCountryName,
      this.eventFlag});

  @override
  String toString() => """ eventId: $eventId,
            eventTitle: $eventTitle,
            eventDate: $eventDate,
            eventFinishDate: $eventFinishDate,
            eventVenue: $eventVenue,
            eventCountryName: $eventCountryName,
            eventFlag: $eventFlag
            information: $information,
            enterWebsite: $eventWebSite 
            eventSepcification: ${eventSpecifications.toString()}""";

}