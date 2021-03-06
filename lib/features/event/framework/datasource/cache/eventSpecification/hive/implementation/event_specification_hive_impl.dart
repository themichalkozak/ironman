import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/hive/abstraction/event_specification_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/model/event_specification_cache_entity.dart';

class EventSpecificationHiveImpl extends EventSpecificationHive {

  Box _box;

  EventSpecificationHiveImpl(this._box);

  @override
  Future<HiveList<EventSpecificationCacheEntity>> createHiveList() async {
    return HiveList(_box);

  }

  @override
  Future<void> insertEventSpecification(EventSpecificationCacheEntity eventSpecification) {
    return _box.put(eventSpecification.id, eventSpecification);
  }

  @override
  Future<void> insertEventSpecificationList(List<EventSpecificationCacheEntity> eventSpecification) async{
    if(eventSpecification != null){
      eventSpecification.forEach((element) {
        insertEventSpecification(element);
      });
    }else {
      throw CacheException(message: EVENT_SPECIFICATION_NULL_ERROR);
    }
  }

  @visibleForTesting
  Future<List<EventSpecificationCacheEntity>> getEventsSpecification () async {
    return _box.values.toList().cast<EventSpecificationCacheEntity>();
  }


}

const String EVENT_SPECIFICATION_NULL_ERROR = 'Event Specification list is null';