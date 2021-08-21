import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/core/domain/usecase.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/event_repository.dart';

class SearchLocalEventsByQuery
    extends UseCaseStream<List<Event>, SearchLocalEventsByQueryParams> {
  final EventRepository repository;
  SearchLocalEventsByQueryParams _searchEventsByQueryParams;

  @visibleForTesting
  SearchLocalEventsByQueryParams get params => _searchEventsByQueryParams;

  SearchLocalEventsByQuery(this.repository);

  @override
  Stream<Either<Failure, List<Event>>> call(SearchLocalEventsByQueryParams params) {
    return repository.searchEventsByQuery(params.query, params.page);
  }
}

class SearchLocalEventsByQueryParams extends Equatable {
  final String query;
  final int page;

  SearchLocalEventsByQueryParams({
    this.query,
    @required this.page
  }): assert(query != null),
        assert(page != null),
        super([query,page]);

}