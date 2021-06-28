import 'package:flutter/cupertino.dart';
import 'package:ironman/core/error/exceptions.dart';
import 'package:ironman/core/error/failure.dart';

class StatusError extends StatelessWidget {

  final Exception _exception;

  const StatusError({
    @required Exception exception,
  }): _exception = exception;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(_getErrorMessageFromException(_exception)),);
  }

  String _getErrorMessageFromException(Exception exception){
    switch(exception.runtimeType){
      case ServerExceptions: return SERVER_FAILURE_MESSAGE;
      case NoInternetConnectionExceptions: return NO_INTERNET_FAILURE_MESSAGE;
      case CacheException: return CACHE_FAILURE_MESSAGE;
    }
  }
}