import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../hive_type_ids.dart';

enum DishStockStatusType {
  added('Добавлено', Colors.white),
  bought('Купленно', Colors.white),
  ready('Готово к употреблению', Color(0x3314BF1B));
  final String label;
  final Color color;

  const DishStockStatusType(this.label, this.color);
}


class DishStockStatusTypeAdapter extends TypeAdapter<DishStockStatusType> {
  @override
  final int typeId = HiveTypeId.dishStockStatus; // Уникальный ID

  @override
  DishStockStatusType read(BinaryReader reader) {
    final index = reader.readInt();
    return DishStockStatusType.values[index];
  }

  @override
  void write(BinaryWriter writer, DishStockStatusType obj) {
    writer.writeInt(obj.index);
  }
}