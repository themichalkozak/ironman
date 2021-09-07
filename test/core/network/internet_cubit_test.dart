import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ironman/core/platform/connection_type.dart';
import 'package:ironman/core/platform/internet_cubit.dart';
import 'package:mockito/mockito.dart';

class MockConnectivity extends Mock implements Connectivity {}

main(){
  TestWidgetsFlutterBinding.ensureInitialized();

  Connectivity mockConnectivity;
  InternetCubit cubit;

  setUp((){
    mockConnectivity = MockConnectivity();
  });

  test('initial state should be Internet Loading', () {
    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((realInvocation) => Stream.value(ConnectivityResult.none));
    cubit = InternetCubit(connectivity: mockConnectivity);
    expect(cubit.state, equals(InternetLoading()));
  });

  blocTest('listening subscription should emit [ConnectionType.mobile]', build: (){
    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((realInvocation) => Stream.value(ConnectivityResult.mobile));
    cubit = InternetCubit(connectivity: mockConnectivity);
  return cubit;
  },
  expect: () => [InternetConnected(ConnectionType.Mobile)]
  );

  blocTest('listening subscription should emit [ InternetConnected(ConnectionType.wifi)]', build: (){
    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((realInvocation) => Stream.value(ConnectivityResult.wifi));
    cubit = InternetCubit(connectivity: mockConnectivity);
    return cubit;
  },
      expect: () => [InternetConnected(ConnectionType.Wifi)]
  );

  blocTest('listening subscription should emit [ InternetConnected(ConnectionType.mobile)]', build: (){
    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((realInvocation) => Stream.value(ConnectivityResult.mobile));
    cubit = InternetCubit(connectivity: mockConnectivity);
    return cubit;
  },
      expect: () => [InternetConnected(ConnectionType.Mobile)]
  );

  blocTest('listening subscription should emit [ InternetDisconnected()]', build: (){
    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((realInvocation) => Stream.value(ConnectivityResult.none));
    cubit = InternetCubit(connectivity: mockConnectivity);
    return cubit;
  },
      expect: () => [InternetDisconnected()]
  );


  test('isInternet connection should return true when emits mobile data',() async {

    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((realInvocation) => Stream.value(ConnectivityResult.mobile));

    when(mockConnectivity.checkConnectivity())
    .thenAnswer((realInvocation) async => ConnectivityResult.mobile);

    cubit = InternetCubit(connectivity: mockConnectivity);
    expect(await cubit.isConnected(), true);
  });

  test('isInternet connection should return true when emits wifi data',() async {

    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((realInvocation) => Stream.value(ConnectivityResult.wifi));

    when(mockConnectivity.checkConnectivity())
        .thenAnswer((realInvocation) async => ConnectivityResult.wifi);

    cubit = InternetCubit(connectivity: mockConnectivity);
    expect(await cubit.isConnected(), true);
  });

  test('isInternet connection should return false when emits ConnectivityResult.none',() async {

    when(mockConnectivity.onConnectivityChanged)
        .thenAnswer((realInvocation) => Stream.value(ConnectivityResult.none));

    when(mockConnectivity.checkConnectivity())
        .thenAnswer((realInvocation) async => ConnectivityResult.none);

    cubit = InternetCubit(connectivity: mockConnectivity);
    expect(await cubit.isConnected(), false);
  });





}