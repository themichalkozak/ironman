import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

const String NO_ELEMENT_FAILURE_MESSAGE = 'Event not found';
const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String NO_INTERNET_FAILURE = 'No internet Connection';
const String NO_INITIAL_STATE_FAILURE = 'No internet Connection';
const String NO_NEXT_PAGE_FAILURE = 'No more element';
const String CACHE_FAILURE = 'Cache Fail';


class Failure extends Equatable {
  final String error;

  Failure({
    this.error,
  }) : super([error]);

  static String mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case NoElementFailure:
        return failure.error ?? NO_ELEMENT_FAILURE_MESSAGE;
      case NoInternetFailure:
        return NO_INTERNET_FAILURE;
      case NoInitialStateFailure:
        return NO_INITIAL_STATE_FAILURE;
      case CacheFailure:
        return CACHE_FAILURE;
      default:
        return 'Unexpected Error';
    }
  }
}

class NoInitialStateFailure extends Failure {}

class NoNextPageFailure extends Failure {}

class ServerFailure extends Failure {
  final String error;

  ServerFailure({
    this.error
  });
}

class NoInternetFailure extends Failure {}

class CacheFailure extends Failure {
  final String error;

  CacheFailure({
    this.error
  });
}

class NoElementFailure extends Failure {
  final String error;

  NoElementFailure({
    this.error,
  });
}
