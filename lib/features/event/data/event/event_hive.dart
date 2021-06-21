import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:ironman/features/event/domain/entity/event.dart';

@HiveType(typeId: 1)
class EventHive extends Event {
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

  EventHive({
    @required this.eventId,
    @required this.eventTitle,
    @required this.eventDate,
    @required this.eventFinishDate,
    @required this.eventVenue,
    @required this.eventCountryName,
    @required this.eventFlag,
  });
}
