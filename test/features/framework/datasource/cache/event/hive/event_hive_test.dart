import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/hive/abstraction/event_hive.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/hive/implementation/event_hive_impl.dart';
import 'package:ironman/features/event/framework/datasource/cache/event/model/event_cache_entity.dart';
import 'package:ironman/features/event/framework/datasource/network/utils/Constants.dart';

void initHive() {
  var path = Directory.current.path;
  Hive.init(path + '/test/hive_testing_path');
  Hive.registerAdapter(EventCacheEntityAdapter());
}


void main() {
  EventHive eventHive;
  Box eventBox;

  initHive();

  setUp(() async {
    eventBox = await Hive.openBox('test');
    eventHive = EventHiveImpl(eventBox);
  });

  tearDown(() async {
    await eventBox.clear();
    await eventBox.close();
  });


  test('should return true when is open', () {
    bool isOpen = eventBox.isOpen;
    expect(isOpen, true);
  });

  EventCacheEntity tEvent = EventCacheEntity(eventId: 0,
      eventTitle: 'title',
      eventDate: DateTime(2021, 02, 01),
      eventFinishDate: DateTime(2021, 02, 01),
      eventVenue: 'Lublin',
      eventCountryName: 'Poland',
      eventFlag: 'eventFlag');


  EventCacheEntity tEvent2 = EventCacheEntity(eventId: 1,
      eventTitle: 'title2',
      eventDate: DateTime(2021, 02, 01),
      eventFinishDate: DateTime(2021, 02, 01),
      eventVenue: 'Lublin',
      eventCountryName: 'Poland',
      eventFlag: 'eventFlag');

  EventCacheEntity tEvent3 = EventCacheEntity(eventId: 2,
      eventTitle: 'title2',
      eventDate: DateTime(2022, 02, 01),
      eventFinishDate: DateTime(2022, 02, 01),
      eventVenue: 'Lublin',
      eventCountryName: 'Poland',
      eventFlag: 'eventFlag');

  EventCacheEntity tEvent4 = EventCacheEntity(eventId: 3,
      eventTitle: 'title2',
      eventDate: DateTime(2023, 02, 01),
      eventFinishDate: DateTime(2022, 02, 01),
      eventVenue: 'Lublin',
      eventCountryName: 'Poland',
      eventFlag: 'eventFlag');

  List<EventCacheEntity> notSortedList = [tEvent3, tEvent4, tEvent2];

  List<EventCacheEntity> sortedListByDateASC = [tEvent2, tEvent3, tEvent4];

  List<EventCacheEntity> sortedListByDateDESC = [tEvent4, tEvent3, tEvent2];

  // should insert when data is correct

  test('insert Event', () async {
    await eventHive.insertEvent(tEvent);

    List<EventCacheEntity> response = await eventHive.getAllEvents();
    expect(response, [tEvent]);
  });

  // should insert list when data is correct

  test('insert events', () async {
    List<EventCacheEntity> list = await _getTestData(20);

    await eventHive.insertEvents(list);

    List<EventCacheEntity> response = await eventHive.getAllEvents();
    expect(response, list);
  });

  // pagination

  test('_setupPagination should return first page', () async {
    List<EventCacheEntity> list = await _getTestData(20);

    await eventHive.insertEvents(list);

    final int perPage = PER_PAGE;

    final newList = eventHive.setupPagination(list, 1, perPage);

    expect(newList, list.take(10));
  });

  test('_setupPagination should return second page', () async {
    List<EventCacheEntity> list = await _getTestData(16);

    await eventHive.insertEvents(list);

    final int perPage = PER_PAGE;

    final newList = eventHive.setupPagination(list, 2, perPage);

    expect(newList, list.getRange(10, 16).toList());
  });

  test('_setupPagination should return empty list', () async {
    List<EventCacheEntity> list = await _getTestData(10);

    await eventHive.insertEvents(list);

    final int perPage = PER_PAGE;

    final newList = eventHive.setupPagination(list, 2, perPage);

    expect(newList, []);
  });

  test('_setupPagination should return list with one element', () async {
    List<EventCacheEntity> list = await _getTestData(11);

    await eventHive.insertEvents(list);

    final int perPage = PER_PAGE;

    final newList = eventHive.setupPagination(list, 2, perPage);

    print(newList);

    expect(newList, list.getRange(10, 11).toList());
  });

  // orderByDate ASC

  test('searchEventsOrderByDateASC return sorted list', () async {
    await eventHive.insertEvents(notSortedList);

    final result = await eventHive.searchEventsOrderByDateASC('', 1);

    expect(result, sortedListByDateASC);

    print('searchEventsOrderByDateASC test finished');
  });

  // orderByDate DESC

  test('searchEventsOrderByDateDESC return sorted list', () async {
    await eventHive.insertEvents(notSortedList);

    final result = await eventHive.searchEventsOrderByDateDESC('', 1);

    expect(result, sortedListByDateDESC);
  });

  // filterByFutureDateASC

  EventCacheEntity tFilterEvent1 = EventCacheEntity(eventId: 0,
      eventTitle: 'title2',
      eventDate: DateTime.now().add(Duration(days: 1)),
      eventFinishDate: DateTime.now().add(Duration(days: 1)),
      eventVenue: 'Lublin',
      eventCountryName: 'Poland',
      eventFlag: 'eventFlag');

  EventCacheEntity tFilterEvent2 = EventCacheEntity(eventId: 1,
      eventTitle: 'title2',
      eventDate: DateTime.now().add(Duration(days: 20)),
      eventFinishDate: DateTime.now().add(Duration(days: 1)),
      eventVenue: 'Lublin',
      eventCountryName: 'Poland',
      eventFlag: 'eventFlag');

  EventCacheEntity tFilterEvent3 = EventCacheEntity(eventId: 2,
      eventTitle: 'title2',
      eventDate: DateTime.now().subtract(Duration(days: 1)),
      eventFinishDate: DateTime.now().subtract(Duration(days: 1)),
      eventVenue: 'Lublin',
      eventCountryName: 'Poland',
      eventFlag: 'eventFlag');

  EventCacheEntity tFilterEvent4 = EventCacheEntity(eventId: 3,
      eventTitle: 'title2',
      eventDate: DateTime.now().subtract(Duration(days: 2)),
      eventFinishDate: DateTime.now().subtract(Duration(days: 2)),
      eventVenue: 'Lublin',
      eventCountryName: 'Poland',
      eventFlag: 'eventFlag');

  List<EventCacheEntity> notFilteredList = [tFilterEvent1,tFilterEvent2,tFilterEvent3,tFilterEvent4];

  List<EventCacheEntity> filterListByFutureDateASC = [tFilterEvent1,tFilterEvent2];

  test('filterByFutureDateASC return filtered list',() async{
     await eventHive.insertEvents(notFilteredList);

     final result = await eventHive.searchEventsFilterByFutureDateASC('', 1);

     expect(result,filterListByFutureDateASC);

  });

  List<EventCacheEntity> filterListByFutureDateDESC = [tFilterEvent3,tFilterEvent4];

  // filterByPastDateDESC

  test('filterByFutureDateDESC return filtered list',() async{
    await eventHive.insertEvents(notFilteredList);

    final result = await eventHive.searchEventsFilterByPastDateDESC('', 1);

    expect(result,filterListByFutureDateDESC);

  });

}

Future<List<EventCacheEntity>> _getTestData(int size) async {
  if (size == 0) {
    return [];
  }

  int i = 0;

  List<EventCacheEntity> list = [];

  while (i < size) {
    list.add(EventCacheEntity(eventId: i,
        eventTitle: 'Title #$i',
        eventDate: DateTime(2021, 02, 01),
        eventFinishDate: DateTime(2021, 02, 01),
        eventVenue: 'Lublin',
        eventCountryName: 'Poland',
        eventFlag: 'eventFlag'));
    i++;
  }

  return list;
}