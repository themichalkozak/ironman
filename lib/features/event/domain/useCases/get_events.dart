import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/usecase.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import '../event_repository.dart';
import '../event_tense.dart';

class GetEvents extends UseCase<List<Event>,GetEventsParams> {
  final EventRepository repository;

  GetEvents(this.repository);

  @override
  Future<Either<Failure, List<Event>>>call(GetEventsParams params) {
    return repository.getEvents(params.eventTense);
  }
}

class GetEventsParams extends Equatable {
  final EventTense eventTense;

  GetEventsParams({
    @required this.eventTense,
  }):super([eventTense]);
}