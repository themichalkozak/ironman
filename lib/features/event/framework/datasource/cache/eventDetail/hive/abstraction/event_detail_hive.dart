import 'package:ironman/features/event/framework/datasource/cache/eventDetail/model/event_detail_cache_entity.dart';

abstract class EventDetailHive {

  Future<void> insertEventDetail(EventDetailCacheEntity eventDetail);

  Future<EventDetailCacheEntity> searchEventById(int id);

}