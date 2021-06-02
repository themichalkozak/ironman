import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/core/failure.dart';
import 'package:ironman/core/usecase.dart';
import 'package:ironman/domain/event/entity/event.dart';
import 'package:ironman/domain/event/event_repository.dart';
import 'package:ironman/domain/event/event_tense.dart';

class GetEvents extends UseCase<List<Event>,Params> {
  final EventRepository repository;

  GetEvents(this.repository);

  @override
  Future<Either<Failure, List<Event>>> call(Params params) {
    return repository.getEvents(params.eventTense);
  }
}

class Params extends Equatable {
  final EventTense eventTense;

  Params({
    @required this.eventTense,
  }):super([eventTense]);
}