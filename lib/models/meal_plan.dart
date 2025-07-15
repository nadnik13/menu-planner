import 'package:my_recipe_app/core/extensions/date_extensions.dart';

import 'package:hive/hive.dart';
import 'hive_type_ids.dart';

part 'meal_plan.g.dart';

@HiveType(typeId: HiveTypeId.mealPlan)
class MealPlan {
  @HiveField(0)
  final DateTime date;
  @HiveField(1)
  final Map<String, int> mealPortions;

  MealPlan({required this.date, required this.mealPortions});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MealPlan &&
            mealPortions.length == other.mealPortions.length &&
            date.dateOnly == other.date.dateOnly &&
            mealPortions == other.mealPortions);
  }

  @override
  int get hashCode => Object.hash(date.dateOnly, mealPortions);
}
