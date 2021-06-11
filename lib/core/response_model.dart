import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:ironman/features/event/domain/response.dart';

class ResponseModel extends Response {
  final String status;
  final dynamic data;
  final String message;

  ResponseModel({
    @required this.status,
    @required this.data,
    this.message,
  });

  factory  ResponseModel.fromJson(Map<String,dynamic> json) {
    return ResponseModel(
      status: json['status'],
      data: json['data'],
      message: json['message']
    );
  }

}