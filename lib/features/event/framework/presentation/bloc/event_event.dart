import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import 'package:ironman/features/event/framework/datasource/cache/hive/abstraction/event_hive.dart';

@immutable
abstract class EventEvent extends Equatable {
  EventEvent([List props = const <dynamic>[]]) : super(props);
}

class EventInitial extends EventEvent {}

class GetEventsEvent extends EventEvent {
  final String orerAndFilter;
  final int page;

  GetEventsEvent({this.orerAndFilter = EVENT_FILTER_QUERY,this.page}) : super([orerAndFilter,page]);
}

class SearchNewQuery extends EventEvent {
  final String query;
  final String orderAndFilter;

  SearchNewQuery({
    this.query,
    this.orderAndFilter
  }): super([query,orderAndFilter]);

}

class SearchNextPageResultEvent extends EventEvent {
  SearchNextPageResultEvent();
}



class UpdateOrderAndFilter extends EventEvent {
  final String orderAndFilter;

  UpdateOrderAndFilter({
    @required this.orderAndFilter,
  });
}

class RefreshSearchEventsByQueryEvent extends EventEvent {
  RefreshSearchEventsByQueryEvent();
}
