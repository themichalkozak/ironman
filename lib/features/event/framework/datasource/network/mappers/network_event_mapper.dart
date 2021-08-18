import 'package:ironman/features/event/businnes/domain/utils/domain_mapper.dart';
import 'package:ironman/features/event/data/event/EventModel.dart';
import 'package:ironman/features/event/domain/entity/event.dart';

class NetworkMapper extends DomainMapper<EventDto,Event> {

  @override
  Event mapFromDomainModel(EventDto model) {
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
  EventDto mapToDomainModel(Event domainModel) {
    return EventDto( eventId: domainModel.eventId,
        eventTitle: domainModel.eventTitle,
        eventDate: domainModel.eventDate,
        eventFinishDate: domainModel.eventFinishDate,
        eventVenue: domainModel.eventVenue,
        eventCountryName: domainModel.eventCountryName,
        eventFlag: domainModel.eventFlag);
  }

}