import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/domain/useCases/get_event_by_id.dart';
import 'package:ironman/features/event/presentation/bloc/detail/bloc.dart';

class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final GetEventById getEventById;

  EventDetailBloc({
    @required this.getEventById,
  })  : assert(getEventById != null),
        super(Empty());

  @override
  Stream<EventDetailState> mapEventToState(EventDetailEvent event) async* {
    if (event is GetEventByIdEvent) {
      yield Loading();
      final failureOrEvents =
          await getEventById(GetEventByIdParams(id: event.id));
      yield failureOrEvents.fold(
          (failure) =>
              Error(errorMessage: Failure.mapFailureToMessage(failure)),
          (event) => Loaded(data: event));
    }
  }
}
