import 'package:ironman/features/event/business/domain/models/event_detail.dart';

abstract class EventDetailServiceDao {

  Future<void> insertEventDetail(EventDetail eventDetail);

  Future<EventDetail> searchEventById(int id);
}