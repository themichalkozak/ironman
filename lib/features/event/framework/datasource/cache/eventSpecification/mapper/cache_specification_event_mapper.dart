import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import 'package:ironman/features/event/business/domain/utils/domain_mapper.dart';
import '../model/event_specification_cache_entity.dart';

class SpecificationEventCacheMapper
    extends DomainMapper<EventSpecification, EventSpecificationCacheEntity> {
  @override
  EventSpecificationCacheEntity mapToDomainModel(EventSpecification model) {
    return EventSpecificationCacheEntity(model.name, model.id, model.parentId);
  }

  @override
  EventSpecification mapFromDomainModel(
      EventSpecificationCacheEntity domainModel) {
    return EventSpecification(
        domainModel.name, domainModel.id, domainModel.parentId);
  }

  List<EventSpecification> mapEntityListToDomainList(HiveList<EventSpecificationCacheEntity> list){

    if(list == null){
      return [];
    }
    List<EventSpecification> domainList = [];
    list.forEach((element) {
      domainList.add(mapFromDomainModel(element));
    });
    return domainList;
  }

  List<EventSpecificationCacheEntity> mapDomainListToEntityList(List<EventSpecification> list){

    List<EventSpecificationCacheEntity> entityList = [];
    list.forEach((element) {
      entityList.add(mapToDomainModel(element));
    });
    return entityList;
  }
}
