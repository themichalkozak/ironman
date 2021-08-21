import 'package:ironman/features/event/business/domain/utils/domain_mapper.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';
import 'package:ironman/features/event/framework/datasource/network/model/event_detailed_dto.dart';

class NetworkMapper extends DomainMapper<EventDetailDto,EventDetail> {
  @override
  EventDetail mapFromDomainModel(EventDetailDto model) {
    return EventDetail(
        eventId: model.eventId,
        eventTitle: model.eventTitle,
        eventDate: model.eventDate,
        eventFinishDate: model.eventFinishDate,
        eventVenue: model.eventVenue,
        eventCountryName: model.eventCountryName,
        eventFlag: model.eventFlag,
      eventSpecifications: model.eventSpecifications,
      eventWebSite: model.eventWebSite,
      information: model.information
    );
  }

  @override
  EventDetailDto mapToDomainModel(EventDetail domainModel) {
    return EventDetailDto(
        eventId: domainModel.eventId,
        eventTitle: domainModel.eventTitle,
        eventDate: domainModel.eventDate,
        eventFinishDate: domainModel.eventFinishDate,
        eventVenue: domainModel.eventVenue,
        eventCountryName: domainModel.eventCountryName,
        eventFlag: domainModel.eventFlag,
        eventSpecifications: domainModel.eventSpecifications,
        eventWebSite: domainModel.eventWebSite,
        information: domainModel.information
    );
  }

}