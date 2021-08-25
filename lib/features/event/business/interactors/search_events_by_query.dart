import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/core/domain/usecase.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/platform/network_info.dart';
import 'package:ironman/features/event/business/data/cache/abstraction/event_cache_data_source.dart';
import 'package:ironman/features/event/business/data/network/abstraction/event_network_data_source.dart';
import '../domain/models/event.dart';

class SearchEventsByQuery
    extends UseCaseStream<List<Event>, SearchEventsByQueryParams> {
  EventNetworkDataSource eventNetworkDataSource;
  EventCacheDataSource eventCacheDataSource;
  NetworkInfo networkInfo;

  SearchEventsByQuery(
      this.eventNetworkDataSource, this.eventCacheDataSource, this.networkInfo);

  @override
  Stream<Either<Failure, List<Event>>> call(
      SearchEventsByQueryParams params) async* {
    if (!await networkInfo.isConnected) {
      try {
        final cachedEvents = await _readCache(params.query, params.page,params.filterAndOrder);
        yield Right(cachedEvents);
      } on CacheException {
        yield Left(CacheFailure());
      }
      return;
    }

    try {
       final result = await _readCache(params.query, params.page,params.filterAndOrder);
       yield Right(result);
      final events = await _apiCall(params.query, params.page,params.filterAndOrder);
      await _cacheEvents(events, params.page);
      final updatedResult = await _readCache(params.query, params.page,params.filterAndOrder);
      yield Right(updatedResult);
    } on ServerExceptions catch (error) {
      yield Left(NetworkFailure(error: error.message));
    } on TimeoutException catch (error) {
      yield Left(TimeoutFailure(error: error.message));
    } on CacheException catch (error) {
      yield Left(CacheFailure(error: error.message));
    }
  }

  Future<List<Event>> _readCache(
      String query, int page, String filterAndOrder) async {
    return eventCacheDataSource.searchEventsByQuery(
        query, page, filterAndOrder);
  }

  Future<List<Event>> _apiCall(String query, int page,String filterAndOrder) {
    return eventNetworkDataSource.searchEvents(query, page,filterAndOrder);
  }

  Future<void> _cacheEvents(List<Event> events, int page) {
    return eventCacheDataSource.insertEvents(events);
  }
}

class SearchEventsByQueryParams extends Equatable {
  final String query;
  final int page;
  final String filterAndOrder;

  SearchEventsByQueryParams(
      {this.query, this.filterAndOrder, @required this.page})
      : assert(query != null),
        assert(page != null),
        assert(filterAndOrder != null),
        super([query, page]);
}
