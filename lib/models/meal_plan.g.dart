// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MealPlanAdapter extends TypeAdapter<MealPlan> {
  @override
  final int typeId = 1;

  @override
  MealPlan read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealPlan(
      date: fields[1] as DateTime,
      meal: fields[0] as Meal,
      portion: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, MealPlan obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.meal)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.portion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MealPlanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
