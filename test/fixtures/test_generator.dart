import 'package:ironman/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/model/event_cache_entity.dart';
import 'package:ironman/features/event/framework/datasource/network/model/event_detailed_dto.dart';
import 'package:ironman/features/event/framework/datasource/network/model/event_dto.dart';

const String TEST_DATE_TIME = '2020-08-01';
final DateTime testDateTime = DateTime(2020, 08, 01);

List<Event> getEvents(int size, [int startIndex]) {

  if(startIndex == null){
    startIndex = 0;
  }
  if (size == 0) {
    return [];
  }

  List<Event> events = [];

  for (int i = 0; i < size; i++) {
    events.add(Event(
        eventId: i,
        eventTitle: "1992 POL Middle Distance Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png"));
  }
  return events.getRange(startIndex, size).toList();
}

Future<List<EventCacheEntity>> getTestEventsCacheEntities(int size) async {
  if (size == 0) {
    return [];
  }

  int i = 0;

  List<EventCacheEntity> list = [];

  while (i < size) {
    list.add(EventCacheEntity(
        eventId: i,
        eventTitle: 'Title #$i',
        eventDate: DateTime(2021, 02, 01),
        eventFinishDate: DateTime(2021, 02, 01),
        eventVenue: 'Lublin',
        eventCountryName: 'Poland',
        eventFlag: 'eventFlag'));
    i++;
  }

  return list;
}

List<EventCacheEntity> getEventsCacheEntity(int size) {
  if (size == 0) {
    return [];
  }

  List<EventCacheEntity> events = [];

  for (int i = 0; i < size; i++) {
    events.add(EventCacheEntity(
        eventId: i,
        eventTitle: "1992 POL Middle Distance Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: DateTime(1992, 01, 01),
        eventFinishDate: DateTime(1992, 01, 01),
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png"));
  }

  return events;
}

List<EventSpecification> getTestEventSpecification() =>
    [EventSpecification('Triathlon', 357, null)];

EventDetail getTestEventDetail() => EventDetail(
    eventId: 149007,
    eventTitle: '1985 Ulster ETU Triathlon Team Relay European Championships',
    eventDate: "1985-06-08",
    eventFinishDate: "1985-06-08",
    eventVenue: 'Ulster',
    eventCountryName: 'Ireland',
    eventFlag: 'https://triathlon-images.imgix.net/images/icons/ie.png',
    eventSpecifications: getTestEventSpecification(),
    eventWebSite: null,
    information: null);

List<EventDto> getEventDto(int size) {
  if (size == 0) {
    return [];
  }

  List<EventDto> events = [];

  for (int i = 0; i < size; i++) {
    events.add(EventDto(
        eventId: i,
        eventTitle: "1992 POL Middle Distance Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png"));
  }
  return events;
}

List<EventDetailDto> getEventDetailDto(int size) {
  if (size == 0) {
    return [];
  }

  List<EventDetailDto> events = [];

  for (int i = 0; i < size; i++) {
    events.add(EventDetailDto(
        eventId: i,
        eventTitle: "1992 POL Middle Distance Triathlon National Championships",
        eventVenue: "",
        eventCountryName: "Poland",
        eventSpecifications: getEventSpecificationDto(size),
        eventDate: "1992-01-01",
        eventFinishDate: "1992-01-01",
        eventFlag: "https://triathlon-images.imgix.net/images/icons/pl.png"));
  }
  return events;
}

List<EventSpecificationDto> getEventSpecificationDto(int size) {
  if (size == 0) {
    return [];
  }

  List<EventSpecificationDto> events = [];

  for (int i = 0; i < size; i++) {
    events.add(EventSpecificationDto(name: 'Triathlon', id: 357, parentId: null));
  }
  return events;
}
