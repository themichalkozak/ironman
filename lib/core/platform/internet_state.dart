part of 'internet_cubit.dart';

@immutable
abstract class InternetState {}
ConnectionType _connectionType;

class InternetConnected extends InternetState {
  final ConnectionType connectionType;

  InternetConnected(this.connectionType);
}

class InternetDisconnected extends InternetState {}

class InternetLoading extends InternetState {}


