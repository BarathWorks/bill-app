// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bill_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BillItemModelAdapter extends TypeAdapter<BillItemModel> {
  @override
  final int typeId = 1;

  @override
  BillItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BillItemModel(
      itemName: fields[0] as String,
      date: fields[1] as DateTime,
      quantity: fields[2] as double,
      rate: fields[3] as double,
      amount: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, BillItemModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.itemName)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.rate)
      ..writeByte(4)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BillItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
