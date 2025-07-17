import 'package:hive/hive.dart';
import 'package:food_planner/models/dish_stock/dish_stock_status_types.dart';
import 'package:food_planner/models/dish_template/dish_template.dart';
import 'package:uuid/uuid.dart';

import '../hive_type_ids.dart';

part 'dish_stock.g.dart';

@HiveType(typeId: HiveTypeId.dishStock)
class DishStock {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? templateId;

  @HiveField(3)
  final int addedCntPortion;

  @HiveField(4)
  final int usedCntPortion;

  @HiveField(5)
  final DishStockStatusType status;

  DishStock(
    this.id,
    this.title,
    this.templateId,
    this.addedCntPortion,
    this.usedCntPortion,
      this.status,
  );

  factory DishStock.add(DishTemplate recipe) {
    final uuid = Uuid();
    final id = uuid.v4();
    return DishStock(id, recipe.title, recipe.id, recipe.portion, 0, DishStockStatusType.added);
  }

  int get availablePortion => addedCntPortion - usedCntPortion;

  DishStock copyWith({int? addedCntPortion, int? usedCntPortion, DishStockStatusType? status}) {
    return DishStock(
      id,
      title,
      templateId,
      addedCntPortion ?? this.addedCntPortion,
      usedCntPortion ?? this.usedCntPortion,
      status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DishStock && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
