import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void runTestsOnline(Function body) {
  group('device is online', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    body();
  });
}

void runTestsOffline(Function body) {
  group('device is offline', () {
    setUp(() {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    body();
  });
}