import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../../business/domain/models/event_detail.dart';

@immutable
class EventDetailState extends Equatable {}

class Empty extends EventDetailState {}

class Loading extends EventDetailState {}

class Loaded extends EventDetailState {
  final EventDetail data;

  Loaded({
    @required this.data,
  });
}

class Error extends EventDetailState {
  final String errorMessage;

  Error({
    @required this.errorMessage,
  });
}
















