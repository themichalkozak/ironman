import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/usecase.dart';
import 'package:ironman/domain/event/entity/event.dart';
import 'package:ironman/domain/event/event_repository.dart';
import 'package:ironman/domain/event/event_tense.dart';

class SearchEventsByQuery extends UseCase<List<Event>, Params> {
  final EventRepository repository;


  SearchEventsByQuery(this.repository);

  @override
  Future<Either<Failure, List<Event>>> call(Params params) {
    return repository.searchEventsByQuery(params.query,params.eventTense);
  }

}

class Params extends Equatable {
  final String query;
  final EventTense eventTense;

  Params({
    @required this.query,
    @required this.eventTense,
  }) :super([query,eventTense]);

}