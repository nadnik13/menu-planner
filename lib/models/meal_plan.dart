import 'package:my_recipe_app/core/extensions/date_extensions.dart';

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
  @HiveField(2)
  final int portion;

  MealPlan({required this.date, required this.recipe, required this.portion});

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is MealPlan &&
            other.runtimeType == runtimeType &&
            recipe == other.recipe &&
            date.dateOnly == other.date.dateOnly);
  }

  @override
  int get hashCode => Object.hash(recipe, date.dateOnly);
}
