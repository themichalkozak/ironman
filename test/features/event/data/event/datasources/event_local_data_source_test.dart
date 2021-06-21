import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/features/event/data/event/event_local_data_source.dart';
import 'package:mockito/mockito.dart';

class MockEventLocalDataSource extends Mock implements Box {}

void main(){
  EventLocalDataSource eventLocalDataSource;
  MockEventLocalDataSource mockEventLocalDataSource;

  setUp((){
    mockEventLocalDataSource = MockEventLocalDataSource();
    eventLocalDataSource = HiveEventLocalDataSourceImpl(mockEventLocalDataSource);
  });

}