import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/models/recipe.dart';
import '../models/meal.dart';

class MealNotifier extends StateNotifier<Set<Meal>> {
  final Box<Meal> _box;

  MealNotifier(this._box) : super(_box.values.toSet());

  void addOrReplaceMeal(Meal meal) {
    _box.put(meal.id, meal);
    state = _box.values.toSet();
  }

  //:TODO что лучше Meal или meal.id
  void updateMeal({required Meal meal, required int usedCntPortion}) {
    final updatedMeal = meal.copyWith(usedCntPortion: usedCntPortion);
    addOrReplaceMeal(updatedMeal);
  }

  void addMealByRecipe(Recipe recipe) {
    bool isNewValue = false;
    final meals = state;
    final meal = meals.firstWhere(
      (e) => e.recipeId != null && e.recipeId == recipe.id,
      orElse: () {
        isNewValue = true;
        return Meal.add(recipe);
      },
    );
    final updatedMeal =
        !isNewValue
            ? meal.copyWith(
              addedCntPortion: meal.addedCntPortion + recipe.portion,
            )
            : meal;
    addOrReplaceMeal(updatedMeal);
  }

  void removeMeal(Meal meal) {
    _box.delete(meal.id);
    state = _box.values.toSet();
  }
}

final mealProvider = StateNotifierProvider<MealNotifier, Set<Meal>>((ref) {
  final box = Hive.box<Meal>('MealBox');
  return MealNotifier(box);
});
