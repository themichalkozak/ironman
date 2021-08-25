// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_detail_cache_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventDetailCacheEntityAdapter
    extends TypeAdapter<EventDetailCacheEntity> {
  @override
  final int typeId = 2;

  @override
  EventDetailCacheEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventDetailCacheEntity(
      eventSpecifications: (fields[0] as HiveList)?.castHiveList(),
      eventWebSite: fields[1] as String,
      information: fields[2] as String,
      eventId: fields[3] as int,
      eventTitle: fields[4] as String,
      eventDate: fields[5] as String,
      eventFinishDate: fields[6] as String,
      eventVenue: fields[7] as String,
      eventCountryName: fields[8] as String,
      eventFlag: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EventDetailCacheEntity obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.eventSpecifications)
      ..writeByte(1)
      ..write(obj.eventWebSite)
      ..writeByte(2)
      ..write(obj.information)
      ..writeByte(3)
      ..write(obj.eventId)
      ..writeByte(4)
      ..write(obj.eventTitle)
      ..writeByte(5)
      ..write(obj.eventDate)
      ..writeByte(6)
      ..write(obj.eventFinishDate)
      ..writeByte(7)
      ..write(obj.eventVenue)
      ..writeByte(8)
      ..write(obj.eventCountryName)
      ..writeByte(9)
      ..write(obj.eventFlag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventDetailCacheEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
