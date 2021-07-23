import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/core/error/failure.dart';
import '../../../../core/domain/usecase.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import '../event_repository.dart';

class SearchEventsByQuery
    extends UseCase<List<Event>, SearchEventsByQueryParams> {
  final EventRepository repository;
  SearchEventsByQueryParams _searchEventsByQueryParams;

  @visibleForTesting
  SearchEventsByQueryParams get params => _searchEventsByQueryParams;

  SearchEventsByQuery(this.repository);

  @override
  Future<Either<Failure, List<Event>>> call(SearchEventsByQueryParams params) {
    return repository.searchEventsByQuery(
        params.query, params.page);
  }

}

class SearchEventsByQueryParams extends Equatable {
  final String query;
  final int page;

  SearchEventsByQueryParams({
    this.query,
    @required this.page
  }): assert(query != null),
        assert(page != null),
        super([query,page]);

}
