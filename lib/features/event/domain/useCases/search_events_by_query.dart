import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/usecase.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import '../event_repository.dart';

class SearchEventsByQuery
    extends UseCase<List<Event>, SearchEventsByQueryParams> {
  final EventRepository repository;

  SearchEventsByQuery(this.repository);

  @override
  Future<Either<Failure, List<Event>>> call(SearchEventsByQueryParams params) {
    return repository.searchEventsByQuery(params.query, params.eventTense);
  }
}

class SearchEventsByQueryParams extends Equatable {
  final String query;
  final EventTense eventTense;

  SearchEventsByQueryParams({
    @required this.query,
    @required this.eventTense,
  })  : assert(query != null),
        super([query, eventTense]);
}
