import 'package:dartz/dartz.dart';
import 'package:ironman/core/error/failure.dart';

abstract class UseCaseStream<Type,Params> {
  Stream<Either<Failure, Type>> call(Params params);
}
