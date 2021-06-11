import 'package:flutter/foundation.dart';

class ServerExceptions implements Exception {
  final String message;

  const ServerExceptions({
    @required this.message,
  });
}

class NoElementExceptions implements Exception {
  final String message;

  const NoElementExceptions({
    @required this.message
  });
}