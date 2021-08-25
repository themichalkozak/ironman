import 'package:ironman/features/event/business/domain/utils/date_util.dart';
import 'package:ironman/features/event/business/domain/utils/domain_mapper.dart';
import '../../../../business/domain/models/event.dart';
import 'package:ironman/features/event/framework/datasource/cache/model/event_cache_entity.dart';

class EventCacheMapper extends DomainMapper<Event, EventCacheEntity> {
  DateUtils dateUtils;

  EventCacheMapper(this.dateUtils);

  @override
  EventCacheEntity mapFromDomainModel(Event model) {
    return EventCacheEntity(
        eventId: model.eventId,
        eventTitle: model.eventTitle,
        eventDate: dateUtils.stringToDate(model.eventDate),
        eventFinishDate: dateUtils.stringToDate(model.eventFinishDate),
        eventVenue: model.eventVenue,
        eventCountryName: model.eventCountryName,
        eventFlag: model.eventFlag);
  }

  @override
  Event mapToDomainModel(EventCacheEntity domainModel) {
    return Event(
        eventId: domainModel.eventId,
        eventTitle: domainModel.eventTitle,
        eventDate: dateUtils.startDateToString(domainModel.eventDate),
        eventFinishDate: dateUtils.startDateToString(domainModel.eventFinishDate),
        eventVenue: domainModel.eventVenue,
        eventCountryName: domainModel.eventCountryName,
        eventFlag: domainModel.eventFlag);
  }

  List<Event> entityListToDomainList(List<EventCacheEntity> events){
    List<Event> list = [];
    events.forEach((element) {
      list.add(mapToDomainModel(element));
    });
    return list;
  }

  List<EventCacheEntity> domainListToEntityList(List<Event> events){
    List<EventCacheEntity> list = [];
    events.forEach((element) {
      list.add(mapFromDomainModel(element));
    });
    return list;
  }

}
