import 'package:ironman/features/event/business/data/network/abstraction/event_network_data_source.dart';
import 'package:ironman/features/event/framework/datasource/network/abstraction/event_api_service.dart';
import '../../../domain/models/event.dart';
import '../../../domain/models/event_detail.dart';
import '../../../../framework/datasource/network/client/abstraction/event_http_client.dart';

class EventNetworkDataSourceImpl extends EventNetworkDataSource {

  final EventApiService eventApiService;

  EventNetworkDataSourceImpl(this.eventApiService);

  @override
  Future<EventDetail> searchEvent(int eventId) async {
    return eventApiService.getEventById(eventId);
  }

  @override
  Future<List<Event>> searchEvents(String query, int page,String filterAndOrder) async {
    return eventApiService.searchEvents(query, page, filterAndOrder);
  }

}