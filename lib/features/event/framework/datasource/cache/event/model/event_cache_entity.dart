import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'event_cache_entity.g.dart';

@HiveType(typeId: 1)
class EventCacheEntity  extends Equatable{

  @HiveField(0)
  final int eventId;

  @HiveField(1)
  final String eventTitle;

  @HiveField(2)
  final DateTime eventDate;

  @HiveField(3)
  final DateTime eventFinishDate;

  @HiveField(4)
  final String eventVenue;

  @HiveField(5)
  final String eventCountryName;

  @HiveField(6)
  final String eventFlag;

  EventCacheEntity({
    @required this.eventId,
    @required this.eventTitle,
    @required this.eventDate,
    @required this.eventFinishDate,
    @required this.eventVenue,
    @required this.eventCountryName,
    @required this.eventFlag,
  });

  @override
  String toString() => ''' id: $eventId title: $eventTitle eventDate: $eventDate \n  ''';

  @override
  List get props => [eventId,eventDate];

}
