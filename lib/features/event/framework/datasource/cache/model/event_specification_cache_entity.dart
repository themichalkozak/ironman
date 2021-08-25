import 'package:hive_flutter/hive_flutter.dart';

part 'event_specification_cache_entity.g.dart';

@HiveType(typeId: 4)
class EventSpecificationCacheEntity extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int id;
  @HiveField(2)
  final int parentId;

  EventSpecificationCacheEntity(this.name, this.id, this.parentId);
}
