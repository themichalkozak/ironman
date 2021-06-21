import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/core/error/failure.dart';
import '../../../../core/domain/usecase.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import '../event_repository.dart';

class SearchEventsByQuery
    extends UseCase<List<Event>, SearchEventsByQueryParams> {
  final EventRepository repository;
  SearchEventsByQueryParams _searchEventsByQueryParams;
  int _page = 1;

  @visibleForTesting
  int get page => _page;

  @visibleForTesting
  SearchEventsByQueryParams get params => _searchEventsByQueryParams;

  SearchEventsByQuery(this.repository);

  @override
  Future<Either<Failure, List<Event>>> call(SearchEventsByQueryParams params,
      [int page]) {
    shouldResetPage(params.query);

    updateParams(params.eventTense, params.query);

    return repository.searchEventsByQuery(
        params.query, params.eventTense, _page);
  }

  bool isInitialQuery() {
    if (_searchEventsByQueryParams == null) {
      return false;
    }
    if (_searchEventsByQueryParams.query == null) {
      return false;
    }
    return true;
  }

  void updateParams(EventTense eventTense, String query) {
    if (eventTense == null || eventTense == null) {
      return;
    }

    _searchEventsByQueryParams =
        SearchEventsByQueryParams(eventTense: eventTense, query: query);
  }

  void incrementPage() {
    _page++;
  }

  void shouldResetPage(String query) {

    if(_searchEventsByQueryParams == null){
      return;
    }

    if(_searchEventsByQueryParams.query == null){
      return;
    }

    if(_searchEventsByQueryParams.query != query){
      resetPage();
    }

  }

  void resetPage() {
    _page = 1;
  }

  Future<Either<Failure, List<Event>>> fetchNextPageResult() async {
    if (!isInitialQuery()) {
      return Left(NoInitialStateFailure());
    }
    incrementPage();
    return call(_searchEventsByQueryParams, _page);
  }
}

class SearchEventsByQueryParams extends Equatable {
  final String query;
  final EventTense eventTense;

  SearchEventsByQueryParams({
    this.query,
    @required this.eventTense,
  })  : assert(query != null),
        assert(eventTense != null),
        super([query, eventTense]);

  SearchEventsByQueryParams copyWith({
    String query,
    EventTense eventTense,
  }) {
    if ((query == null || identical(query, this.query)) &&
        (eventTense == null || identical(eventTense, this.eventTense))) {
      return this;
    }

    return new SearchEventsByQueryParams(
      query: query ?? this.query,
      eventTense: eventTense ?? this.eventTense,
    );
  }
}
