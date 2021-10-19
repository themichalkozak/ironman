import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/platform/internet_cubit.dart';
import 'package:ironman/features/event/business/data/cache/abstraction/event_cache_data_source.dart';
import 'package:ironman/features/event/business/data/network/abstraction/event_network_data_source.dart';
import 'package:ironman/features/event/business/domain/models/event_detail.dart';
import '../../../../core/domain/usecase.dart';
import '../domain/models/event.dart';

class GetEventById extends UseCase<Event, GetEventByIdParams> {

  final EventNetworkDataSource eventNetworkDataSource;
  final EventCacheDataSource eventCacheDataSource;
  final InternetCubit internetCubit;

  GetEventById(this.eventNetworkDataSource, this.eventCacheDataSource,
      this.internetCubit);

  @override
  Stream<Either<Failure, EventDetail>> call(GetEventByIdParams params) async* {
    try {
      EventDetail cacheResult = await eventCacheDataSource.searchEvent(
          params.id);

      if (cacheResult == null) {
        if (await internetCubit.isConnected()) {
          print('get_event_by_id | apiCall');
          final result = await apiCall(params.id);
          await eventCacheDataSource.insertEventDetail(result);
          cacheResult = await eventCacheDataSource.searchEvent(params.id);
          yield(Right(cacheResult));
        } else {
          yield(Left(NoElementFailure()));
        }
      } else {
        print('get_event_by_id | cacheCall | cacheResult: $cacheResult');
        yield Right(cacheResult);
      }
    } on ServerExceptions catch (error) {
      print('get_event_by_id | call | error exception: ${error.message}');
      yield Left(NetworkFailure());
    } on CacheException catch (error) {
      yield Left(CacheFailure(error: error.message));
    } on NoElementExceptions {
      yield Left(NoElementFailure());
    } on TimeoutException catch (error) {
      yield Left(TimeoutFailure(error: error.message));
    } catch (error) {
      yield Left(NetworkFailure(error: error.toString()));
    }
  }

  Future<EventDetail> apiCall(int eventId) async =>
      await eventNetworkDataSource.searchEvent(eventId);


}

class GetEventByIdParams extends Equatable {
  final int id;

  GetEventByIdParams({
    @required this.id,
  }) : super([id]);
}
