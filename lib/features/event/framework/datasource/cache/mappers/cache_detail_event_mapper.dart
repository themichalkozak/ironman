import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import 'package:ironman/features/event/business/domain/utils/domain_mapper.dart';
import 'package:ironman/features/event/framework/datasource/cache/mappers/cache_specification_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/cache/model/event_detail_cache_entity.dart';

class EventDetailCacheMapper extends DomainMapper<EventDetail,EventDetailCacheEntity> {

  final SpecificationEventCacheMapper cacheSpecificationEventMapper;

  EventDetailCacheMapper(this.cacheSpecificationEventMapper);

  @override
  EventDetailCacheEntity mapFromDomainModel(EventDetail model) {
    return EventDetailCacheEntity(
      eventSpecifications: cacheSpecificationEventMapper.mapDomainListToEntityList(model.eventSpecifications),
      eventWebSite: model.eventWebSite,
      information: model.information,
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
  EventDetail mapToDomainModel(EventDetailCacheEntity domainModel) {
    return EventDetail(
        eventSpecifications: cacheSpecificationEventMapper.mapEntityListToDomainList(domainModel.eventSpecifications),
        eventWebSite: domainModel.eventWebSite,
        information: domainModel.information,
        eventId: domainModel.eventId,
        eventTitle: domainModel.eventTitle,
        eventDate: domainModel.eventDate,
        eventFinishDate: domainModel.eventFinishDate,
        eventVenue: domainModel.eventVenue,
        eventCountryName: domainModel.eventCountryName,
        eventFlag: domainModel.eventFlag
    );
  }

}