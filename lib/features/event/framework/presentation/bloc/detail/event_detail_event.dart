
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class EventDetailEvent extends Equatable {
  EventDetailEvent([List props = const <dynamic>[]]) : super(props);
}

class GetEventByIdEvent extends EventDetailEvent {
  final int id;

  GetEventByIdEvent({
    @required this.id,
  }):super([id]);
}