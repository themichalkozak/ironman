import 'package:flutter/foundation.dart';
import 'package:ironman/domain/entities/event/event_listing_response.dart';

class EventDetailResponse extends EventListingResponse {

  final List<EventSpecification> eventSpecifications;
  final String eventWebSite;
  final String information;

  EventDetailResponse({
    @required this.eventSpecifications,
    @required this.eventWebSite,
    @required this.information,
  });
}

class EventSpecification {
  final String name;
  final int id;
  final int parentId;

  EventSpecification(this.name, this.id, this.parentId);
}