import 'package:flutter/material.dart';
import '../features/event/domain/repsonse.dart';

class ResponseModel<T> extends Response {
  final String status;
  final int currentPage;
  final int lastPage;
  final List<T> data;
  final String message;

  ResponseModel({
    @required this.status,
    @required this.currentPage,
    @required this.lastPage,
    @required this.data,
    this.message,
  });

  factory ResponseModel.fromJson(Map<String,dynamic> json) {
    return ResponseModel(
      status: json['status'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      data: json['data'] as List,
      message: json['message']
    );
  }
}