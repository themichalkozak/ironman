import 'package:ironman/features/event/business/data/network/abstraction/event_network_data_source.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';
import 'package:ironman/features/event/framework/datasource/network/abstraction/event_api_service.dart';

class EventNetworkDataSourceImpl extends EventNetworkDataSource {

  final EventApiService eventApiService;


  EventNetworkDataSourceImpl(this.eventApiService);

  @override
  Future<EventDetail> searchEvent(Event event) async {
    return eventApiService.getEventById(event.eventId);
  }

  @override
  Future<List<Event>> searchEvents(String query, int page,String filterAndOrder) async {
    return eventApiService.searchFilteredEvents(query, page, filterAndOrder);
  }

}