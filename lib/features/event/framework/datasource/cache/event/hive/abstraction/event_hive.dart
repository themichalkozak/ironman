import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import '../../model/event_cache_entity.dart';
import '../../../eventDetail/model/event_detail_cache_entity.dart';

const EVENT_PAGINATION_PAGE_SIZE = 10;

const String EVENT_ORDER_ASC = '';
const String EVENT_ORDER_DESC = '-';
const String EVENT_ORDER_DATE = 'date';

const String EVENT_FILTER_FUTURE_DATE = 'future_date';
const String EVENT_FILTER_PAST_DATE = 'past_date';
const String EVENT_FILTER_QUERY = 'query';

const String ORDER_BY_DESC_PAST_DATE = EVENT_ORDER_ASC + EVENT_FILTER_PAST_DATE;
const String ORDER_BY_ASC_FUTURE_DATE = EVENT_ORDER_ASC + EVENT_FILTER_FUTURE_DATE;
const String ORDER_BY_DATE_ASC = EVENT_ORDER_ASC + EVENT_FILTER_QUERY;

abstract class EventHive {

  Future<void> insertEvent(EventCacheEntity event);

  Future<void> insertEvents(List<EventCacheEntity> events);

  Future<List<EventCacheEntity>> getAllEvents();

  Future<List<EventCacheEntity>> searchEventsOrderByDateASC(String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE});

  Future<List<EventCacheEntity>> searchEventsFilterByFutureDateASC(String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE,DateTime dateTime});

  Future<List<EventCacheEntity>> searchEventsFilterByPastDateDESC(String query, int page,
      {int pageSize = EVENT_PAGINATION_PAGE_SIZE,DateTime dateTime});

  Future<List<EventCacheEntity>> returnOrderedQuery(
      String query, String filterAndOrder, int page);

  List<EventCacheEntity> setupPagination(List<EventCacheEntity> events, int page, int perPage);
}
