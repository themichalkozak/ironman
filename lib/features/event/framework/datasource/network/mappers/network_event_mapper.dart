import 'package:ironman/features/event/business/domain/utils/domain_mapper.dart';
import '../../../../business/domain/models/event.dart';
import 'package:ironman/features/event/framework/datasource/network/model/event_dto.dart';

class EventNetworkMapper extends DomainMapper<EventDto,Event> {

  @override
  Event mapToDomainModel(EventDto model) {
    return Event(
      eventId: model.eventId,
      eventTitle: model.eventTitle,
      eventDate: model.eventDate,
      eventFinishDate: model.eventFinishDate,
      eventVenue: model.eventVenue,
      eventCountryName: model.eventCountryName,
      eventFlag: model.eventFlag
    );
  }

  @override
  EventDto mapFromDomainModel(Event domainModel) {
    return EventDto( eventId: domainModel.eventId,
        eventTitle: domainModel.eventTitle,
        eventDate: domainModel.eventDate,
        eventFinishDate: domainModel.eventFinishDate,
        eventVenue: domainModel.eventVenue,
        eventCountryName: domainModel.eventCountryName,
        eventFlag: domainModel.eventFlag);
  }

  List<EventDto> mapDomainListToEntityList(List<Event> list){
    if(list == null || list.isEmpty){
      return null;
    }
    List<EventDto> convertedList = [];

    list.forEach((element) {
      convertedList.add(mapFromDomainModel(element));
    });
    return convertedList;
  }

  List<Event> mapEntityListToDomainList(List<EventDto> list){
    if(list == null || list.isEmpty){
      return null;
    }
    List<Event> convertedList = [];

    list.forEach((element) {
      convertedList.add(mapToDomainModel(element));
    });
    return convertedList;
  }

}