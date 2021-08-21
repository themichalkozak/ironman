import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';

abstract class EventNetworkDataSource {

  Future<List<Event>> searchEvents(String query, int page,String filterAndOrder);

  Future<EventDetail> searchEvent(Event event);

}