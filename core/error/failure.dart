
import 'package:equatable/equatable.dart';

class Failure extends Equatable {
  
  Failure([List properties = const <dynamic>[]]) : super(properties);
}

class ServerFailure extends Failure {}

class NoInternetFailure extends Failure {}
class NoElementFailure extends Failure {}
