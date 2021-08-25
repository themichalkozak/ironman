import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../business/domain/models/event_detail.dart';
import 'package:ironman/features/event/framework/datasource/cache/hive/abstraction/event_hive.dart';

@immutable
abstract class EventState extends Equatable {
  EventState([List props = const <dynamic>[]]) : super(props);
}

class Empty extends EventState {}

class Loading extends EventState {}

class Loaded extends EventState {
  final List events;
  final bool isExhausted;
  final String orderAndFilter;

  Loaded({
    @required this.events,
    @required this.isExhausted,
    this.orderAndFilter = EVENT_FILTER_QUERY
  }): super([events,isExhausted,orderAndFilter]);

  Loaded copyWith({
    List events,
    bool isExhausted,
    String orderAndFilter,
  }) {
    if ((events == null || identical(events, this.events)) &&
        (isExhausted == null || identical(isExhausted, this.isExhausted)) &&
        (orderAndFilter == null || identical(orderAndFilter, this.orderAndFilter))) {
      return this;
    }

    return new Loaded(
      events: events ?? this.events,
      isExhausted: isExhausted ?? this.isExhausted,
      orderAndFilter: orderAndFilter ?? this.orderAndFilter,
    );
  }

  @override
  String toString() => 'Loaded | events.length: ${events.length} | isExhausted: $isExhausted | orderAndFilter" $orderAndFilter';
}

class LoadedDetail extends EventState {
  final EventDetail event;

  LoadedDetail({
    @required this.event,
  }): assert(event != null)
  ,super([event]);
}

class Error extends EventState {
  final String errorMessage;

  Error({
    @required this.errorMessage,
  }):super([errorMessage]);
}
