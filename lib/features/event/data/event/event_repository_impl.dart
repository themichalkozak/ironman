import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/platform/network_info.dart';
import 'package:ironman/features/event/data/event/event_local_data_source.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';
import 'event_remote_data_source.dart';
import '../../domain/event_repository.dart';

class EventRepositoryImpl extends EventRepository {
  final EventRemoteDataSource remoteDataSource;
  final EventLocalDataSource  localDataSource;
  final NetworkInfo networkInfo;

  EventRepositoryImpl({
    @required this.remoteDataSource,
    @required this.networkInfo,
    @required this.localDataSource
  });

  @override
  Future<Either<Failure, EventDetail>> searchEventById(int id) async {

    if(!await networkInfo.isConnected){


      try{

        final EventDetail event = await localDataSource.searchEventById(id);

        if(event == null){
          return Left(NoElementFailure());
        }

        return Right(event);

      }catch(error){
        return Left(CacheFailure(error: error.toString()));
      }

    }

    try{

      final EventDetail event = await remoteDataSource.getEventById(id);

      if(event == null){
        return Left(NoElementFailure());
      }

      localDataSource.cacheSingleEvent(event);
      return Right(event);

    } on ServerExceptions{
      return Left(NoElementFailure());
    }
  }

  @override
  Future<Either<Failure, List<Event>>> searchEventsByQuery(
      String query,int page) async {

    if(!await networkInfo.isConnected){
      try{
        final cachedEvents = await localDataSource.searchEventsByQuery(query, page);
        return Right(cachedEvents);
      } on CacheException{
        return Left(CacheFailure());
      }
    }

    try{
      final events = await remoteDataSource.searchEventsByQuery(query,page);
      localDataSource.cacheEvents(events, page);
      return Right(events);
    }on ServerExceptions catch(error) {
      return Left(ServerFailure(error: error.message));
    } on TimeoutException catch(error){
      return Left(TimeoutFailure(error: error.message));
    }
  }
}
