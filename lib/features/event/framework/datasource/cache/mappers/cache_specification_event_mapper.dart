import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import 'package:ironman/features/event/business/domain/utils/domain_mapper.dart';
import 'package:ironman/features/event/framework/datasource/cache/model/event_specification_cache_entity.dart';

class SpecificationEventCacheMapper
    extends DomainMapper<EventSpecification, EventSpecificationCacheEntity> {
  @override
  EventSpecificationCacheEntity mapFromDomainModel(EventSpecification model) {
    return EventSpecificationCacheEntity(model.name, model.id, model.parentId);
  }

  @override
  EventSpecification mapToDomainModel(
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
      domainList.add(mapToDomainModel(element));
    });
    return domainList;
  }

  HiveList<EventSpecificationCacheEntity> mapDomainListToEntityList(List<EventSpecification> list){

    HiveList<EventSpecificationCacheEntity> entityList = HiveList(box)
    list.forEach((element) {
      entityList.add(mapFromDomainModel(element));
    });
    return entityList;
  }
}
