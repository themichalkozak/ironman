part of 'internet_cubit.dart';

@immutable
abstract class InternetState extends Equatable {
  InternetState([List props = const <dynamic>[]]) : super(props);

}
ConnectionType _connectionType;

class InternetConnected extends InternetState {
  final ConnectionType connectionType;

  InternetConnected(this.connectionType):super([connectionType]);
}

class InternetDisconnected extends InternetState {}

class InternetLoading extends InternetState {}


