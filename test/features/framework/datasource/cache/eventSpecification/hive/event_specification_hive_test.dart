
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/hive/abstraction/event_specification_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/hive/implementation/event_specification_hive_impl.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/model/event_specification_cache_entity.dart';

void initHive(){
  var path = Directory.current.path;
  Hive.init(path + '/test/hive_testing_path');
  Hive.registerAdapter(EventSpecificationCacheEntityAdapter());
}

void main(){
  Box box;
  EventSpecificationHive eventSpecificationHive;

  initHive();

  setUp(() async {
    box = await Hive.openBox('testSpec');
    eventSpecificationHive = EventSpecificationHiveImpl(box);
  });

  tearDown(() async {
    await box.clear();
    await box.close();
  });

  EventSpecificationCacheEntity tModel = EventSpecificationCacheEntity
    ('name', 1,1);

  test('insert',() async {
    await eventSpecificationHive.insertEventSpecification(tModel);

    await eventSpecificationHive.insertEventSpecification(tModel);

    final result = await eventSpecificationHive.getEventsSpecification();

    expect(result,[tModel]);
  });
}