import 'package:equatable/equatable.dart';

abstract class Response extends Equatable {
  final String status;
  final int currentPage;
  final int lastPage;

  Response(
    this.status,
    this.currentPage,
    this.lastPage,
  );
}
