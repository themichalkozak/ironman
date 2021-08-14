import 'package:dartz/dartz.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';

abstract class EventRepository {

  Stream<Either<Failure, List<Event>>> searchEventsByQuery(
      String query, int page);

  Stream<Either<Failure, List<Event>>> searchLocalEventsByQuery(
      String query, int page);

  Future<Either<Failure, EventDetail>> searchEventById(int id);

  Stream<Either<Failure, List<Event>>> searchUpcomingEventsByQuery(
      String query, int page,DateTime dateTime);
}
