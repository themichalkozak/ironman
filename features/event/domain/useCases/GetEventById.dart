import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:ironman/core/error/failure.dart';
import 'package:ironman/core/usecase.dart';
import 'package:ironman/features/event/domain/entity/event.dart';
import 'package:ironman/features/event/domain/entity/event_detail.dart';
import '../event_repository.dart';

class GetEventById extends UseCase<Event, GetEventByIdParams> {
  final EventRepository repository;

  GetEventById(this.repository);

  @override
  Future<Either<Failure, EventDetail>> call(GetEventByIdParams params) {
    return repository.getEventById(params.id);
  }
}

class GetEventByIdParams extends Equatable {
  final int id;

  GetEventByIdParams({
    @required this.id,
  }) : super([id]);
}
