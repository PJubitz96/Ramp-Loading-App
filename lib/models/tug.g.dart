// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tug.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TugAdapter extends TypeAdapter<Tug> {
  @override
  final int typeId = 1;

  @override
  Tug read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tug(
      id: fields[0] as String,
      label: fields[1] as String,
      colorIndex: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Tug obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.colorIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TugAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
