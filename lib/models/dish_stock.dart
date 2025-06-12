import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/models/dish_template.dart';
import 'package:uuid/uuid.dart';

import 'dish_stock_status_type.dart';
import 'hive_type_ids.dart';

part 'dish_stock.freezed.dart';
part 'dish_stock.g.dart';

@freezed
@HiveType(typeId: HiveTypeId.dishStock)
class DishStock with _$DishStock {
  @JsonSerializable()
  const factory DishStock({
    @HiveField(0) required String id,
    @HiveField(1) required String title,
    @HiveField(2) required String dishTemplateId,
    @HiveField(3) required int addedCntPortions,
    @HiveField(4) required int usedCntPortions,
    @HiveField(5) required DishStockStatusType status,
  }) = _DishStock;

  factory DishStock.add(DishTemplate template) {
    final uuid = Uuid();
    final id = uuid.v4();
    return DishStock(
      id: id,
      title: template.title,
      dishTemplateId: template.id,
      addedCntPortions: template.portions,
      usedCntPortions: 0,
      status: DishStockStatusType.added,
    );
  }

  const DishStock._();

  int get availablePortion => addedCntPortions - usedCntPortions;

  factory DishStock.fromJson(Map<String, dynamic> json) => _$DishStockFromJson(json);
}
