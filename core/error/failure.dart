import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Failure extends Equatable {
  final String error;

  Failure({
    this.error,
  }) : super([error]);
}

class ServerFailure extends Failure {}

class NoInternetFailure extends Failure {}

class NoElementFailure extends Failure {
  final String error;

  NoElementFailure({
    this.error,
  });
}
