import 'package:flutter/foundation.dart';
import 'package:ironman/features/event/framework/datasource/network/model/models.dart';
import '../domain/response.dart';

class GenericResponse extends Response {
  final String status;
  final dynamic data;
  final String message;
  final int currentPage;
  final int lastPage;

  GenericResponse({
    @required this.status,
    @required this.data,
    this.currentPage,
    this.lastPage,
    this.message,
  });

  factory  GenericResponse.fromJson(Map<String,dynamic> json) {
    return GenericResponse(
      status: json['status'],
      data: json['data'],
      message: json['message'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
    );
  }

  static List<EventDto> mapDtoFromJson(List<dynamic> initial){
    return initial.map((e) => EventDto.fromJson(e)).toList();
  }

}