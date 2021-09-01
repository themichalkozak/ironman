import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'connection_type.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:meta/meta.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {

  final Connectivity connectivity;
  StreamSubscription connectivityStreamSubscription;

  InternetCubit({
    @required this.connectivity
  }): super(InternetLoading()){
    connectivityStreamSubscription = connectivity.onConnectivityChanged.listen((connectivityResult) {

      print('internet_cubit | connectivityResult: $connectivityResult');
      print('internet_cubit | connectivity: ${connectivity.hashCode}');

      if(connectivityResult == ConnectivityResult.mobile){
        emitInternetConnection(ConnectionType.Mobile);
      }else if(connectivityResult == ConnectivityResult.wifi){
        emitInternetConnection(ConnectionType.Wifi);
      }else {
        emitInternetDisconnected();
      }

    });
  }

  Future<bool> isConnected() async {
    final ConnectivityResult result = await connectivity.checkConnectivity();
    if(result == ConnectivityResult.mobile || result == ConnectivityResult.wifi){
      return true;
    }
    return false;
  }

  void emitInternetConnection(ConnectionType connectionType){
    emit(InternetConnected(connectionType));
  }

  void emitInternetDisconnected() => emit(InternetDisconnected());

  @override
  Future<void> close() {
    connectivityStreamSubscription.cancel();
    return super.close();
  }

}
