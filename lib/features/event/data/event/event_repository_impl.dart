import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/platform/network_info.dart';
import 'package:ironman/core/utils/date_format.dart';
import 'package:ironman/features/event/data/event/event_local_data_source.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';
import 'event_remote_data_source.dart';
import '../../domain/event_repository.dart';

class EventRepositoryImpl extends EventRepository {
  final EventRemoteDataSource remoteDataSource;
  final EventLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  EventRepositoryImpl(
      {@required this.remoteDataSource,
      @required this.networkInfo,
      @required this.localDataSource});

  @override
  Future<Either<Failure, EventDetail>> searchEventById(int id) async {
    if (!await networkInfo.isConnected) {
      try {
        final EventDetail event = await localDataSource.searchEventById(id);

        if (event == null) {
          return Left(NoElementFailure());
        }

        return Right(event);
      } catch (error) {
        return Left(CacheFailure(error: error.toString()));
      }
    }

    try {
      final EventDetail event = await remoteDataSource.getEventById(id);

      if (event == null) {
        return Left(NoElementFailure());
      }
      _cacheSingleEvent(event);
      return Right(event);
    } on ServerExceptions {
      return Left(NoElementFailure());
    }
  }

  @override
  Stream<Either<Failure, List<Event>>> searchEventsByQuery(
      String query, int page) async* {
    if (!await networkInfo.isConnected) {
      try {
        final cachedEvents = await _readCache(query, page);
        yield Right(cachedEvents);
      } on CacheException {
        yield Left(CacheFailure());
      }
      return;
    }

    try {
      final result = await _readCache(query, page);
      yield Right(result);
      final events = await _apiCall(query, page);
      await _cacheEvents(events, page);
      final updatedResult = await _readCache(query, page);
      yield Right(updatedResult);
    } on ServerExceptions catch (error) {
      yield Left(NetworkFailure(error: error.message));
    } on TimeoutException catch (error) {
      yield Left(TimeoutFailure(error: error.message));
    } on CacheException catch (error) {
      yield Left(CacheFailure(error: error.message));
    }
  }

  @override
  Stream<Either<Failure, List<Event>>> searchLocalEventsByQuery(
      String query, int page) async* {
    try {
      final cachedEvents = await _readCache(query, page);
      yield Right(cachedEvents);
    } on CacheException {
      yield Left(CacheFailure());
    }
  }

  @override
  Stream<Either<Failure, List<Event>>> searchUpcomingEventsByQuery(
      String query, int page, [DateTime dateTime]) async* {

    if(dateTime == null){
      dateTime = DateTime.now();
    }

    if (!await networkInfo.isConnected) {
      try {
        final cache =
            await localDataSource.searchEventsByQuery(query, page, dateTime);
        yield Right(cache);
      } on CacheException {
        yield Left(CacheFailure());
      }
      return;
    }

    try {
      final cache = await _readCache(query, page, dateTime);
      yield Right(cache);
      final formattedDateTime = formatStartDate(dateTime);
      final result =
          await _apiCallUpcomingEvents(query, page, formattedDateTime);
      yield Right(result);
    } on ServerExceptions {
      yield Left(NetworkFailure());
    } on TimeoutException {
      yield Left(TimeoutFailure());
    } on CacheException {
      yield Left(CacheFailure());
    }
  }

  Future<List<Event>> _apiCallUpcomingEvents(
      String query, int page, String dateTime) {
    return remoteDataSource.searchUpcomingEventsByQuery(query, page, dateTime);
  }

  Future<List<Event>> _readCache(String query, int page,
      [DateTime dateTime]) async {
    return localDataSource.searchEventsByQuery(query, page, dateTime);
  }

  Future<List<Event>> _apiCall(String query, int page) {
    return remoteDataSource.searchEventsByQuery(query, page);
  }

  Future<void> _cacheEvents(List<Event> events, int page) {
    return localDataSource.cacheEvents(events, page);
  }

  Future<void> _cacheSingleEvent(Event event) {
    return localDataSource.cacheSingleEvent(event);
  }
}
