import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

abstract class Response<T> extends Equatable {
  final String status;
  final int currentPage;
  final int lastPage;
  final List<T> data;

  Response({
    @required this.status,
    @required this.currentPage,
    @required this.lastPage,
    @required this.data,
  });
}
