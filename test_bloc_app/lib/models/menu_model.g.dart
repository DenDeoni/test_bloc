// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MenuModelAdapter extends TypeAdapter<MenuModel> {
  @override
  final int typeId = 1;

  @override
  MenuModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MenuModel(
      id: fields[0] as int,
      name: fields[1] as String,
      description: fields[2] as String,
      priceSet: fields[3] as double,
      priceDish: fields[4] as double,
      isSetAdded: fields[5] as bool,
      isDishAdded: fields[6] as bool,
      unit: fields[7] as String,
      cook: fields[8] as bool,
      dish: fields[9] as bool,
      image: fields[10] as String,
      category: fields[11] as Category,
      countSet: fields[12] as int,
      countDish: fields[13] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MenuModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.priceSet)
      ..writeByte(4)
      ..write(obj.priceDish)
      ..writeByte(5)
      ..write(obj.isSetAdded)
      ..writeByte(6)
      ..write(obj.isDishAdded)
      ..writeByte(7)
      ..write(obj.unit)
      ..writeByte(8)
      ..write(obj.cook)
      ..writeByte(9)
      ..write(obj.dish)
      ..writeByte(10)
      ..write(obj.image)
      ..writeByte(11)
      ..write(obj.category)
      ..writeByte(12)
      ..write(obj.countSet)
      ..writeByte(13)
      ..write(obj.countDish);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MenuModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 2;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Category(
      name: fields[0] as String,
      alias: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.alias);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
