
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/model/event_specification_cache_entity.dart';

abstract class EventSpecificationHive {

  Future<void> insertEventSpecification(EventSpecificationCacheEntity eventSpecification);

  Future<void> insertEventSpecificationList(List<EventSpecificationCacheEntity> eventSpecification);

  Future<HiveList<EventSpecificationCacheEntity>> createEventSpecificationList ();
}