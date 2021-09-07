import 'package:ironman/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/business/domain/models/event_detail.dart';

abstract class EventApiService {

  Future<EventDetail> getEventById(int id);

  Future<List<Event>> searchEvents(String query, int page, String filterAndOrder);
}