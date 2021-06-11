import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class ListingResponse<T> extends Equatable {
  final String status;
  final int currentPage;
  final int lastPage;
  final List<T> data;

  ListingResponse({
    @required this.status,
    @required this.currentPage,
    @required this.lastPage,
    @required this.data,
  });
}
