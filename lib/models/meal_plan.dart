import '../models/recipe.dart';
import 'package:hive/hive.dart';
import 'hive_type_ids.dart';

part 'meal_plan.g.dart';

@HiveType(typeId: HiveTypeId.mealPlan)
class MealPlan {
  @HiveField(0)
  final Recipe recipe;
  @HiveField(1)
  final DateTime date;

  MealPlan({required this.date, required this.recipe});

  // TODO: может свой тип date создать чтобы не мучаться?
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MealPlan &&
            other.runtimeType == runtimeType &&
            recipe == other.recipe &&
            date.year == other.date.year &&
            date.month == other.date.month &&
            date.day == other.date.day);
  }

  @override
  int get hashCode => Object.hash(recipe, date.year, date.month, date.day);
}
