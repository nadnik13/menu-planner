import 'package:my_recipe_app/core/extensions/date_extensions.dart';

import 'package:hive/hive.dart';
import 'hive_type_ids.dart';
import 'meal.dart';

part 'meal_plan.g.dart';

@HiveType(typeId: HiveTypeId.mealPlan)
class MealPlan {
  @HiveField(0)
  final Meal meal;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final int portion;

  MealPlan({required this.date, required this.meal, required this.portion});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MealPlan &&
            other.runtimeType == runtimeType &&
            meal == other.meal &&
            date.dateOnly == other.date.dateOnly);
  }

  @override
  int get hashCode => Object.hash(meal, date.dateOnly);
}
