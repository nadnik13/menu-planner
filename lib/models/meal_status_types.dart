import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'hive_type_ids.dart';

enum MealStatusType {
  added('Добавлено', Colors.white),
  bought('Купленно', Colors.white),
  ready('Готово к употреблению', Color(0x3314BF1B));
  final String label;
  final Color color;

  const MealStatusType(this.label, this.color);
}


class MealStatusTypeAdapter extends TypeAdapter<MealStatusType> {
  @override
  final int typeId = HiveTypeId.mealStatus; // Уникальный ID

  @override
  MealStatusType read(BinaryReader reader) {
    final index = reader.readInt();
    return MealStatusType.values[index];
  }

  @override
  void write(BinaryWriter writer, MealStatusType obj) {
    writer.writeInt(obj.index);
  }
}