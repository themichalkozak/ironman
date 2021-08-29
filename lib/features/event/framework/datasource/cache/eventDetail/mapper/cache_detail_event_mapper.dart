import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/mapper/cache_specification_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/model/event_specification_cache_entity.dart';
import '../model/event_detail_cache_entity.dart';

class EventDetailCacheMapper {

  final SpecificationEventCacheMapper cacheSpecificationEventMapper;

  EventDetailCacheMapper(this.cacheSpecificationEventMapper);

  EventDetailCacheEntity mapFromDomainModel(EventDetail model,HiveList<EventSpecificationCacheEntity> eventSpecifications) {
    return EventDetailCacheEntity(
      eventSpecifications: eventSpecifications,
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