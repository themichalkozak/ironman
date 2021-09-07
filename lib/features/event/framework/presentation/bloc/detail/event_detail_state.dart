import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../../business/domain/models/event_detail.dart';

@immutable
class EventDetailState extends Equatable {
  EventDetailState([List props = const <dynamic>[]]) : super(props);
}

class Initial extends EventDetailState {}

class Loading extends EventDetailState {}

class Loaded extends EventDetailState {
  final EventDetail data;

  Loaded({
    @required this.data,
  }):super([data]);
}

class Error extends EventDetailState {
  final String errorMessage;

  Error({
    @required this.errorMessage,
  });
}
















