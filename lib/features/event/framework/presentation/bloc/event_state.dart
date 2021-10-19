import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../business/domain/models/event_detail.dart';
import '../../datasource/cache/event/hive/abstraction/event_hive.dart';

@immutable
abstract class EventState extends Equatable {
  EventState([List props = const <dynamic>[]]) : super(props);
}

class Initial extends EventState {}

class Loading extends EventState {}

class Loaded extends EventState {
  final List events;
  final bool isExhausted;
  final bool isTimeout;
  final String orderAndFilter;

  Loaded({
    @required this.events,
    @required this.isExhausted,
    this.isTimeout = false,
    this.orderAndFilter = EVENT_FILTER_QUERY
  }): super([events,isExhausted,orderAndFilter,isTimeout]);

  Loaded copyWith({
    List events,
    bool isExhausted,
    bool isTimeout,
    String orderAndFilter,
  }) {
    if ((events == null || identical(events, this.events)) &&
        (isExhausted == null || identical(isExhausted, this.isExhausted)) &&
        (isTimeout == null || identical(isTimeout, this.isTimeout)) &&
        (orderAndFilter == null ||
            identical(orderAndFilter, this.orderAndFilter))) {
      return this;
    }

    return new Loaded(
      events: events ?? this.events,
      isExhausted: isExhausted ?? this.isExhausted,
      isTimeout: isTimeout ?? this.isTimeout,
      orderAndFilter: orderAndFilter ?? this.orderAndFilter,
    );
  }

  @override
  String toString() => 'Loaded | events.length: ${events.length} | isExhausted: $isExhausted | isTimeout: $isTimeout | orderAndFilter" $orderAndFilter';
}

class Error extends EventState {
  final String errorMessage;

  Error({
    @required this.errorMessage,
  }):super([errorMessage]);
}
