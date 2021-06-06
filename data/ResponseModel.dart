import 'package:flutter/material.dart';
import 'package:ironman/domain/repsonse.dart';

class ResponseModel extends Response {
  final String status;
  final int currentPage;
  final int lastPage;
  final List data;
  final String message;

  ResponseModel({
    @required this.status,
    @required this.currentPage,
    @required this.lastPage,
    @required this.data,
    @required this.message,
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