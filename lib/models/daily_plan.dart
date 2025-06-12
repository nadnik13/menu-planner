import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'dish_stock.dart';
import 'hive_type_ids.dart';

part 'daily_plan.freezed.dart';
part 'daily_plan.g.dart';

@freezed
@HiveType(typeId: HiveTypeId.dailyPlan)
class DailyPlan with _$DailyPlan {
  const factory DailyPlan({
    @HiveField(0) required DateTime date,
    @HiveField(1) required List<DishStock> dishes,
  }) = _DailyPlan;

  factory DailyPlan.fromJson(Map<String, dynamic> json) =>
      _$DailyPlanFromJson(json);
} 