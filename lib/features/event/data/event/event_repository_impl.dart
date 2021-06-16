import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/platform/network_info.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';
import 'package:ironman/features/event/domain/event_tense.dart';
import 'event_remote_data_source.dart';
import '../../domain/event_repository.dart';

class EventRepositoryImpl extends EventRepository {
  final EventRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  EventRepositoryImpl({
    @required this.remoteDataSource,
    @required this.networkInfo,
  });

  @override
  Future<Either<Failure, EventDetail>> getEventById(int id) async {

    if(!await networkInfo.isConnected){
      return Left(NoInternetFailure());
    }

    try{
      return Right(await remoteDataSource.getEventById(id));
    } on ServerExceptions{
      return Left(NoElementFailure());
    }
  }

  @override
  Future<Either<Failure, List<Event>>> searchEventsByQuery(
      String query, EventTense eventTense,int page) async {

    if(!await networkInfo.isConnected){
      return Left(NoInternetFailure());
    }
    try{
      return Right(await remoteDataSource.searchEventsByQuery(query, eventTense,page));
    }on ServerExceptions {
      return Left(ServerFailure());
    }on NoElementExceptions catch(error) {
      return Left(NoElementFailure(error: error.message));
    }
  }
}
