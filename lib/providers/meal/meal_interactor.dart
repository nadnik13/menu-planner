import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/models/recipe.dart';
import 'package:my_recipe_app/providers/meal/meal_repository.dart';
import '../../models/meal.dart';

class MealInteractor {
  final MealRepository repo;

  MealInteractor(this.repo);

  Future<Set<Meal>> loadMeals() async => await repo.fetchAllMeals();

  Future<void> addMeal(Meal meal) async {
    await repo.addOrReplaceMeal(meal);
  }

  //:TODO что лучше Meal или meal.id
  Future<void> updateMeal({
    required Meal meal,
    required int usedCntPortion,
  }) async {
    final updatedMeal = meal.copyWith(usedCntPortion: usedCntPortion);
    await repo.addOrReplaceMeal(updatedMeal);
  }

  Future<void> updateMeals({required Map<String, int> mealsMap}) async {
    for (final entry in mealsMap.entries) {
      final meal = await repo.getMealByKey(entry.key);
      if (meal != null) {
        await updateMeal(meal: meal, usedCntPortion: entry.value);
      }
    }
  }

  Future<void> addMealByRecipe(Recipe recipe) async {
    bool isNewValue = false;
    final meals = await repo.fetchAllMeals();
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
    repo.addOrReplaceMeal(updatedMeal);
  }

  Future<void> removeMeal(Meal meal) async {
    await repo.removeMealById(meal.id);
  }
}

final mealRepositoryProvider = Provider((ref) {
  final box = Hive.box<Meal>('MealBox');
  return MealRepository(box);
});

final mealInteractorProvider = Provider((ref) {
  return MealInteractor(ref.read(mealRepositoryProvider));
});
