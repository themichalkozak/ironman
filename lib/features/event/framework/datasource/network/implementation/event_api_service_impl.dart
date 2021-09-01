import 'package:ironman/features/event/business/domain/models/event.dart';
import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import 'package:ironman/features/event/framework/datasource/network/abstraction/event_api_service.dart';
import 'package:ironman/features/event/framework/datasource/network/client/abstraction/event_http_client.dart';
import 'package:ironman/features/event/framework/datasource/network/mappers/network_event_detail_mapper.dart';
import 'package:ironman/features/event/framework/datasource/network/mappers/network_event_mapper.dart';

class EventApiServiceImpl extends EventApiService {
  final EventHttpClient eventHttpClient;
  final EventNetworkMapper eventNetworkMapper;
  final DetailEventNetworkMapper detailEventNetworkMapper;

  EventApiServiceImpl(this.eventHttpClient, this.eventNetworkMapper,
      this.detailEventNetworkMapper);

  @override
  Future<EventDetail> getEventById(int id) async => detailEventNetworkMapper
      .mapToDomainModel(await eventHttpClient.getEventById(id));

  @override
  Future<List<Event>> searchEventsByQuery(String query, int page) async =>
      eventNetworkMapper.mapEntityListToDomainList(
          await eventHttpClient.searchEventsByQuery(query, page));

  @override
  Future<List<Event>> searchFilteredEvents(
          String query, int page, String filterAndOrder) async =>
      eventNetworkMapper.mapEntityListToDomainList(await eventHttpClient
          .searchFilteredEvents(query, page, filterAndOrder));

  @override
  Future<List<Event>> searchPastEvents(
          String query, int page, String dateTime) async =>
      eventNetworkMapper.mapEntityListToDomainList(
          await eventHttpClient.searchPastEvents(query, page, dateTime));

  @override
  Future<List<Event>> searchUpcomingEventsByQuery(
          String query, int page, String dateTime) async =>
      eventNetworkMapper.mapEntityListToDomainList(await eventHttpClient
          .searchUpcomingEventsByQuery(query, page, dateTime));
}
