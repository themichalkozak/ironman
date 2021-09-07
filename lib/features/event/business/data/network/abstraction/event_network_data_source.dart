import '../../../domain/models/event.dart';
import '../../../domain/models/event_detail.dart';

abstract class EventNetworkDataSource {

  Future<List<Event>> searchEvents(String query, int page,String filterAndOrder);

  Future<EventDetail> searchEvent(int eventId);

}