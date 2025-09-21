// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddressModelAdapter extends TypeAdapter<AddressModel> {
  @override
  final int typeId = 0;

  @override
  AddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddressModel(
      cep: fields[0] as String,
      logradouro: fields[1] as String,
      complemento: fields[2] as String,
      bairro: fields[3] as String,
      localidade: fields[4] as String,
      estado: fields[5] as String,
      erro: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AddressModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.cep)
      ..writeByte(1)
      ..write(obj.logradouro)
      ..writeByte(2)
      ..write(obj.complemento)
      ..writeByte(3)
      ..write(obj.bairro)
      ..writeByte(4)
      ..write(obj.localidade)
      ..writeByte(5)
      ..write(obj.estado)
      ..writeByte(6)
      ..write(obj.erro);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
