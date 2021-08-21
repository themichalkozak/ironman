import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/domain/useCases/search_events_by_query.dart';
import '../../../../core/domain/usecase.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import '../event_repository.dart';

class SearchUpcomingEventsByQuery
    extends UseCaseStream<List<Event>, SearchUpcomingEventsByQueryParams> {
  final EventRepository repository;
  SearchUpcomingEventsByQueryParams _searchEventsByQueryParams;

  @visibleForTesting
  SearchUpcomingEventsByQueryParams get params => _searchEventsByQueryParams;

  SearchUpcomingEventsByQuery(this.repository);

  @override
  Stream<Either<Failure, List<Event>>> call(SearchUpcomingEventsByQueryParams params) {
    return repository.searchUpcomingEventsByQuery(
        params.query, params.page);
  }

}

class SearchUpcomingEventsByQueryParams extends Equatable {
  final String query;
  final int page;

  SearchUpcomingEventsByQueryParams({
    this.query,
    @required this.page
  }): assert(query != null),
        assert(page != null),
        super([query,page]);

}

