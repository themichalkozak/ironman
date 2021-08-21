import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';

abstract class EventNetworkDataSource {

  Future<List<Event>> searchEventsByQuery(String query, int page);

  Future<EventDetail> searchEvent(Event event);

  Future<List<Event>> searchUpcomingEventsByQuery(String query, int page, String startDateTime);
}