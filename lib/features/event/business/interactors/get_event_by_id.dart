import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/business/data/cache/abstraction/event_cache_data_source.dart';
import 'package:ironman/features/event/business/data/network/abstraction/event_network_data_source.dart';
import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import 'package:ironman/features/event/framework/datasource/network/mappers/network_event_detail_mapper.dart';
import '../../../../core/domain/usecase.dart';
import '../domain/models/event.dart';

class GetEventById extends UseCaseStream<Event, GetEventByIdParams> {

  final EventNetworkDataSource eventNetworkDataSource;
  final EventCacheDataSource eventCacheDataSource;
  final NetworkMapper networkMapper;


  GetEventById(this.eventNetworkDataSource, this.eventCacheDataSource,this.networkMapper);

  @override
  Stream<Either<Failure, EventDetail>> call(GetEventByIdParams params) async* {

    try{
      EventDetail cacheResult = await eventCacheDataSource.searchEvent(params.id);

      if(cacheResult == null){
        print('get_event_by_id | apiCall');
        final result = await apiCall(params.id);
        await eventCacheDataSource.insertEventDetail(result);
        cacheResult = await eventCacheDataSource.searchEvent(params.id);
        yield(Right(cacheResult));
      }else {
        print('get_event_by_id | cacheCall');
        yield Right(cacheResult);
      }

    }on ServerExceptions catch(error){
      print('get_event_by_id | call | error exception: ${error.message}');
      yield Left(NetworkFailure());
    }on CacheException catch(error){
      yield Left(CacheFailure(error: error.message));
    }on NoElementExceptions {
      yield Left(NoElementFailure());
    }

  }

  Future<EventDetail> apiCall(int eventId) async{
    EventDetail response = await eventNetworkDataSource.searchEvent(eventId);
    return networkMapper.mapToDomainModel(response);
  }

}

class GetEventByIdParams extends Equatable {
  final int id;

  GetEventByIdParams({
    @required this.id,
  }) : super([id]);
}
