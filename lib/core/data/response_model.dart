import 'package:flutter/foundation.dart';
import '../domain/response.dart';

class ResponseModel extends Response {
  final String status;
  final dynamic data;
  final String message;
  final int currentPage;
  final int lastPage;

  ResponseModel({
    @required this.status,
    @required this.data,
    this.currentPage,
    this.lastPage,
    this.message,
  });

  factory  ResponseModel.fromJson(Map<String,dynamic> json) {
    return ResponseModel(
      status: json['status'],
      data: json['data'],
      message: json['message'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }

}