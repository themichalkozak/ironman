// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_detailed_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventDetailModelAdapter extends TypeAdapter<EventDetailModel> {
  @override
  final int typeId = 2;

  @override
  EventDetailModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventDetailModel(
      eventId: fields[0] as int,
      eventTitle: fields[1] as String,
      eventDate: fields[2] as String,
      eventFinishDate: fields[3] as String,
      eventVenue: fields[4] as String,
      eventCountryName: fields[5] as String,
      eventFlag: fields[6] as String,
      eventSpecifications: (fields[7] as List)?.cast<EventSpecificationModel>(),
      eventWebSite: fields[8] as String,
      information: fields[9] as String,
    );
  }

  @override
  void write(BinaryWriter writer, EventDetailModel obj) {
    writer
      ..writeByte(10)
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
      ..write(obj.eventFlag)
      ..writeByte(7)
      ..write(obj.eventSpecifications)
      ..writeByte(8)
      ..write(obj.eventWebSite)
      ..writeByte(9)
      ..write(obj.information);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventDetailModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EventSpecificationModelAdapter
    extends TypeAdapter<EventSpecificationModel> {
  @override
  final int typeId = 3;

  @override
  EventSpecificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EventSpecificationModel(
      name: fields[0] as String,
      id: fields[1] as int,
      parentId: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, EventSpecificationModel obj) {
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
      other is EventSpecificationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
