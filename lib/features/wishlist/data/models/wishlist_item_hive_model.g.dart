// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint

part of 'wishlist_item_hive_model.dart';

class WishlistItemHiveModelAdapter extends TypeAdapter<WishlistItemHiveModel> {
  @override
  final int typeId = 2;

  @override
  WishlistItemHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WishlistItemHiveModel(
      productId: fields[0] as String,
      title: fields[1] as String,
      brand: fields[2] as String,
      price: fields[3] as double,
      originalPrice: fields[4] as double?,
      imageUrl: fields[5] as String,
      savedAt: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, WishlistItemHiveModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.productId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.brand)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.originalPrice)
      ..writeByte(5)
      ..write(obj.imageUrl)
      ..writeByte(6)
      ..write(obj.savedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WishlistItemHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
