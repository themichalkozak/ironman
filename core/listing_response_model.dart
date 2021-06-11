import 'package:flutter/material.dart';
import '../features/event/domain/listing_response.dart';

class ListingResponseModel<T> extends ListingResponse {
  final String status;
  final int currentPage;
  final int lastPage;
  final List<T> data;
  final String message;

  ListingResponseModel({
    @required this.status,
    @required this.currentPage,
    @required this.lastPage,
    @required this.data,
    this.message,
  });

  factory ListingResponseModel.fromJson(Map<String,dynamic> json) {
    return ListingResponseModel(
      status: json['status'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      data: json['data'] as List,
      message: json['message']
    );
  }

}