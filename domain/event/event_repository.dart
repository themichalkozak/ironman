import 'package:dartz/dartz.dart';
import 'package:ironman/core/failure.dart';
import 'package:ironman/domain/event/entity/event_detailed_response.dart';
import 'package:ironman/domain/event/entity/event_list_response.dart';
import 'package:ironman/domain/event/event_tense.dart';

abstract class EventRepository {
  Future<Either<Failure, EventListingResponse>> getEvents(
      EventTense eventTense);

  Future<Either<Failure, EventListingResponse>> getEventsByQuery(
      String query, EventTense eventTense);

  Future<Either<Failure, EventDetailResponse>> getEventById(int id);
}
