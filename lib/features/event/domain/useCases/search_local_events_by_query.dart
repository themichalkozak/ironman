import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/core/domain/usecase.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/event_repository.dart';
import 'package:ironman/features/event/domain/useCases/search_events_by_query.dart';

class SearchLocalEventsByQuery
    extends UseCaseStream<List<Event>, SearchEventsByQueryParams> {
  final EventRepository repository;
  SearchEventsByQueryParams _searchEventsByQueryParams;

  @visibleForTesting
  SearchEventsByQueryParams get params => _searchEventsByQueryParams;

  SearchLocalEventsByQuery(this.repository);

  @override
  Stream<Either<Failure, List<Event>>> call(SearchEventsByQueryParams params) {
    return repository.searchEventsByQuery(params.query, params.page);
  }
}
