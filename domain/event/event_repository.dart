import 'package:dartz/dartz.dart';
import 'package:ironman/core/failure.dart';
import 'package:ironman/domain/event/entity/event_detail.dart';
import 'package:ironman/domain/event/entity/event.dart';
import 'package:ironman/domain/event/event_tense.dart';

abstract class EventRepository {
  Future<Either<Failure, List<Event>>> getEvents(
      EventTense eventTense);

  Future<Either<Failure, Event>> getEventsByQuery(
      String query, EventTense eventTense);

  Future<Either<Failure, EventDetailResponse>> getEventById(int id);
}
