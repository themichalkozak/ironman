// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_hive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventHiveAdapter extends TypeAdapter<EventHive> {
  @override
  final int typeId = 1;

  @override
  EventHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventHive(
      eventId: fields[0] as int,
      eventTitle: fields[1] as String,
      eventDate: fields[2] as String,
      eventFinishDate: fields[3] as String,
      eventVenue: fields[4] as String,
      eventCountryName: fields[5] as String,
      eventFlag: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EventHive obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.eventId)
      ..writeByte(1)
      ..write(obj.eventTitle)
      ..writeByte(2)
      ..write(obj.eventDate)
      ..writeByte(3)
      ..write(obj.eventFinishDate)
      ..writeByte(4)
      ..write(obj.eventVenue)
      ..writeByte(5)
      ..write(obj.eventCountryName)
      ..writeByte(6)
      ..write(obj.eventFlag);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
