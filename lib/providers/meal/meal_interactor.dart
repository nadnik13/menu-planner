import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/core/logger.dart';
import 'package:my_recipe_app/models/meal_status_types.dart';
import 'package:my_recipe_app/models/recipe.dart';
import 'package:my_recipe_app/providers/meal/meal_repository.dart';
import '../../models/meal.dart';
import 'meal_provider.dart';
import 'package:collection/collection.dart';

class MealInteractor {
  final MealRepository repo;
  final MealNotifier notifier;

  MealInteractor(this.repo, this.notifier);

  Future<void> loadMeals() async {
    final meals = await repo.fetchAllMeals();
    notifier.addMeals(meals);
  }
  void _printMealBox() {
    final box = Hive.box<Meal>('mealBox');
    logger.d('📦 Всего блюд: ${box.length}');
    box.toMap().forEach((key, value) {
      logger.d('🔑 $key → ${value.title}');
    });
  }

  int getCntAvailablePortion() {
    logger.d("getStatistic");
    _printMealBox();
    final value = notifier.getCntAvailablePortion();

    logger.d("getAvailableMeals: ${notifier.getAvailableMeals().length}");
    return value;
  }

  Map<String, String> getMealTitleMap() => notifier.getTitleMap();

  Set<Meal> getAvailableMeals() => notifier.getAvailableMeals();

  Future<void> addOrReplaceMeal(Meal meal) async {
    await repo.addOrReplaceMeal(meal);
    notifier.addOrReplaceMeal(meal);
  }

  //:TODO что лучше Meal или meal.id
  Future<void> updateMealPortion({
    required Meal meal,
    required int usedCntPortion,
  }) async {
    final updatedMeal = meal.copyWith(usedCntPortion: usedCntPortion);
    await repo.addOrReplaceMeal(updatedMeal);
    notifier.addOrReplaceMeal(updatedMeal);
  }

  Future<void> updateMealStatusByKey({
    required String key,
    required MealStatusType? status,
  }) async {
    final meal = notifier.getMealByKey(key);
    if (meal == null ||  status == null) return;
    final updatedMeal = meal.copyWith(status: status);
    logger.d('updateMealStatus ${updatedMeal.title} ${updatedMeal.status}');
    await repo.addOrReplaceMeal(updatedMeal);
    notifier.addOrReplaceMeal(updatedMeal);
  }

  Future<void> updateMeals({required Map<String, int> mealsMap}) async {
    for (final entry in mealsMap.entries) {
      final meal = notifier.getMealByKey(entry.key);
      if (meal != null) {
        await updateMealPortion(meal: meal, usedCntPortion: entry.value);
      }
    }
  }

  Future<void> addMealByRecipe(Recipe recipe) async {
    final mealByRecipe = notifier.findByRecipeKey(recipe.id).firstOrNull;
    Meal updatedMeal =
        mealByRecipe != null
            ? mealByRecipe.copyWith(
              addedCntPortion: mealByRecipe.addedCntPortion + recipe.portion,
            )
            : Meal.add(recipe);
    addOrReplaceMeal(updatedMeal);
  }

  Future<void> removeMealByKey(String key) async {
    await repo.removeMealByKey(key);
    notifier.removeMealByKey(key);
  }
}

final mealRepositoryProvider = Provider((ref) {
  final box = Hive.box<Meal>('MealBox');
  return MealRepository(box);
});

final mealInteractorProvider = Provider((ref) {
  return MealInteractor(
    ref.read(mealRepositoryProvider),
    ref.read(mealProvider.notifier),
  );
});
