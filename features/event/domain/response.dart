import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class Response extends Equatable {
  final String status;
  final dynamic data;
  final String message;

  Response({
    @required this.status,
    @required this.data,
    this.message
  });
}
