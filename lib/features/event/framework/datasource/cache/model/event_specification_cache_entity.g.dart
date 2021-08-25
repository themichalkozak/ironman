// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_specification_cache_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventSpecificationCacheEntityAdapter
    extends TypeAdapter<EventSpecificationCacheEntity> {
  @override
  final int typeId = 4;

  @override
  EventSpecificationCacheEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventSpecificationCacheEntity(
      fields[0] as String,
      fields[1] as int,
      fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EventSpecificationCacheEntity obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.parentId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventSpecificationCacheEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
