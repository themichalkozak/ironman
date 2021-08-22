import 'package:ironman/features/event/framework/datasource/network/model/models.dart';

abstract class EventApiService {

  Future<List<EventDto>> searchEventsByQuery(String query, int page);

  Future<EventDetailDto> getEventById(int id);

  Future<List<EventDto>> searchUpcomingEventsByQuery(String query, int page, String dateTime);

  Future<List<EventDto>> searchPastEvents(String query, int page, String dateTime);

  Future<List<EventDto>> searchFilteredEvents(String query, int page, String filterAndOrder);
}