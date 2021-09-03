import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/abstraciton/event_detail_service_dao.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/hive/abstraction/event_detail_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/mapper/cache_detail_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/model/event_detail_cache_entity.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/hive/abstraction/event_specification_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/mapper/cache_specification_event_mapper.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/model/event_specification_cache_entity.dart';

class EventDetailServiceDaoImpl extends EventDetailServiceDao {

  EventDetailCacheMapper detailMapper;
  SpecificationEventCacheMapper specMapper;
  EventDetailHive detailHive;
  EventSpecificationHive specificationHive;

  EventDetailServiceDaoImpl(this.detailMapper, this.detailHive,this.specMapper,this.specificationHive);

  @override
  Future<void> insertEventDetail(EventDetail eventDetail) async {

    List<EventSpecificationCacheEntity> entityList = [];
    List<EventSpecification> domainList = eventDetail.eventSpecifications;

    domainList.forEach((element) {
      entityList.add(specMapper.mapFromDomainModel(element));
    });

    specificationHive.insertEventSpecificationList(entityList);
    HiveList <EventSpecificationCacheEntity> hiveList = await specificationHive.createHiveList();
    hiveList.addAll(entityList);


    return detailHive.insertEventDetail(detailMapper.mapFromDomainModel(eventDetail,hiveList));
  }

  @override
  Future<EventDetail> searchEventById(int id) async {
    final EventDetailCacheEntity entity = await detailHive.searchEventById(id);
    if(entity != null){
      return detailMapper.mapToDomainModel(entity);
    }
    return null;
  }

}