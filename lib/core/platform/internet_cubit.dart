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
      if(connectivityResult == ConnectivityResult.mobile){
        emitInternetConnection(ConnectionType.Mobile);
      }else if(connectivityResult == ConnectivityResult.wifi){
        emitInternetConnection(ConnectionType.Wifi);
      }else {
        emitInternetDisconnected();
      }

    });
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
