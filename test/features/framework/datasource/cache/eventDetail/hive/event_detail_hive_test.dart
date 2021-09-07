import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/hive/abstraction/event_detail_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/hive/implementation/event_detail_hive_impl.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventDetail/model/event_detail_cache_entity.dart';
import 'package:ironman/features/event/framework/datasource/cache/eventSpecification/model/event_specification_cache_entity.dart';

void initHive() {
  var path = Directory.current.path;
  Hive.init(path + '/test/hive_testing_path');
  Hive.registerAdapter(EventDetailCacheEntityAdapter());
  Hive.registerAdapter(EventSpecificationCacheEntityAdapter());
}

void main() {
  initHive();

  Box detailEventBox;
  Box eventSpecificationBox;
  EventDetailHive eventDetailHive;


  setUp(() async {
    detailEventBox = await Hive.openBox('test');
    eventSpecificationBox = await Hive.openBox('specTest');
    eventDetailHive = EventDetailHiveImpl(detailEventBox);


  });

  tearDown(() async {
    await detailEventBox.clear();
    await eventSpecificationBox.clear();
    await detailEventBox.close();
    await eventSpecificationBox.close();
  });
  EventSpecificationCacheEntity tEventSpecificationCacheEntity =
  EventSpecificationCacheEntity('name', 1, 1);

  EventSpecificationCacheEntity tEventSpecificationCacheEntity2 =
  EventSpecificationCacheEntity('name', 2, 2);

  EventSpecificationCacheEntity tEventSpecificationCacheEntity3 =
  EventSpecificationCacheEntity('name', 3, 3);

  List<EventSpecificationCacheEntity> tSpecList = [
    tEventSpecificationCacheEntity,
    tEventSpecificationCacheEntity2,
    tEventSpecificationCacheEntity3
  ];

  test('insertDetailEvent', () async {

    eventSpecificationBox.addAll(tSpecList);
    final HiveList<EventSpecificationCacheEntity> hList = HiveList(eventSpecificationBox);

    EventDetailCacheEntity tEvent = EventDetailCacheEntity(
        eventSpecifications: hList,
        eventWebSite: '',
        information: '',
        eventId : 0,
        eventTitle: 'Title',
        eventDate: '22-01-01',
        eventFinishDate: '22-01-01',
        eventVenue: 'Lublin',
        eventCountryName: 'Poland',
        eventFlag: '');

      await eventDetailHive.insertEventDetail(tEvent);

      final result = await eventDetailHive.searchEventById(tEvent.eventId);

      expect(result,tEvent);
  });

}
