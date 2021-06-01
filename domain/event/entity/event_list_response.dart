import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class EventListingResponse extends Equatable {
  final int eventId;
  final String eventTitle;
  final String eventDate;
  final String eventFinishDate;
  final String eventVenue;
  final String eventCountryName;
  final String eventFlag;

  EventListingResponse({
    @required this.eventId,
    @required this.eventTitle,
    @required this.eventDate,
    @required this.eventFinishDate,
    @required this.eventVenue,
    @required this.eventCountryName,
    @required this.eventFlag,
  });

  @override
  List get props => [
        eventId,
        eventTitle,
        eventDate,
        eventFinishDate,
        eventVenue,
        eventCountryName,
        eventFlag
      ];
}
