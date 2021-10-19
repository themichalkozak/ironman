import 'dart:async';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/core/domain/usecase.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/platform/internet_cubit.dart';
import 'package:ironman/features/event/business/data/cache/abstraction/event_cache_data_source.dart';
import 'package:ironman/features/event/business/data/network/abstraction/event_network_data_source.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/hive/abstraction/event_hive.dart';
import '../domain/models/event.dart';

class SearchEventsByQuery
    extends UseCase<List<Event>, SearchEventsByQueryParams> {
  EventNetworkDataSource eventNetworkDataSource;
  EventCacheDataSource eventCacheDataSource;
  InternetCubit internetCubit;

  SearchEventsByQuery(
      this.eventNetworkDataSource, this.eventCacheDataSource, this.internetCubit);

  @override
  Stream<Either<Failure, List<Event>>> call(
      SearchEventsByQueryParams params) async* {

    try {

      print('search_events_by_query | is an Internet: ${await internetCubit.isConnected()}');

      List<Event> _cachedEvents = await _readCache(params.query, params.page, params.filterAndOrder);

      if(_cachedEvents == null || _cachedEvents.length < EVENT_PAGINATION_PAGE_SIZE){

        if(!await internetCubit.isConnected() && _cachedEvents == null){
          yield Right([]);
          return;
        }

        List<Event> _apiResult = await _apiCall(params.query, params.page, params.filterAndOrder);

        if(_apiResult == null && _cachedEvents == null){
          yield Right([]);
          return;
        }

        await _cacheEvents(_apiResult, params.page);

        _cachedEvents = await _readCache(params.query, params.page, params.filterAndOrder);

        if(_cachedEvents == null){
          yield Right([]);
          return;
        }

        yield Right(_cachedEvents);
        return;
      }

      yield Right(_cachedEvents);

    } on ServerExceptions catch (error) {
      yield Left(NetworkFailure(error: error.message));
    } on TimeoutException catch (error) {
      yield Left(TimeoutFailure(error: error.message));
    } on CacheException catch (error) {
      yield Left(CacheFailure(error: error.message));
    } on SocketException catch (error) {
      print('Socket Exception: $error');
    }

  }

  Future<List<Event>> _readCache(
      String query, int page, String filterAndOrder) async {
    return eventCacheDataSource.searchEvents(
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
