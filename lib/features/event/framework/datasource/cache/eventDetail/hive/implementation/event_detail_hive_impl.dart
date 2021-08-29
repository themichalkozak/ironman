import 'package:hive_flutter/adapters.dart';
import '../abstraction/event_detail_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/model/event_detail_cache_entity.dart';

class EventDetailHiveImpl extends EventDetailHive {

  final Box _box;

  EventDetailHiveImpl(this._box);

  @override
  Future<void> insertEventDetail(EventDetailCacheEntity eventDetail) async {
    return _box.put(eventDetail.eventId, eventDetail);
  }

  @override
  Future<EventDetailCacheEntity> searchEventById(int id) async {
    return _box.get(id);
  }

}