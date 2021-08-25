import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/business/interactors/get_event_by_id.dart';

import 'bloc.dart';


class EventDetailBloc extends Bloc<EventDetailEvent, EventDetailState> {
  final GetEventById getEventById;

  EventDetailBloc({
    @required this.getEventById,
  })  : assert(getEventById != null),
        super(Empty());

  EventDetailState get initialState => Empty();

  @override
  Stream<EventDetailState> mapEventToState(EventDetailEvent event) async* {
    if (event is GetEventByIdEvent) {

      yield Loading();

      final failureOrEvents = getEventById(GetEventByIdParams(id: event.id));

      await for (var event in failureOrEvents){
        yield event.fold(
                (failure) =>
                Error(errorMessage: Failure.mapFailureToMessage(failure)),
                (event) => Loaded(data: event));
      }

    }
  }
}
