import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/models/recipe.dart';
import 'package:my_recipe_app/providers/meal/meal_interactor.dart';
import 'package:my_recipe_app/providers/meal/meal_repository.dart';

import '../../models/meal.dart';

class MealNotifier extends StateNotifier<Set<Meal>> {
  final MealRepository repo;
  final MealInteractor interactor;

  MealNotifier(this.repo, this.interactor) : super(<Meal>{}) {
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    state = await repo.fetchAllMeals();
  }

  Map<String, Meal> getMap() => {for (var e in state) e.id: e};

  Future<void> addOrReplaceMeal(Meal meal) async {
    await repo.addOrReplaceMeal(meal);
    await _loadMeals();
  }

  Future<void> updateMeal({required Meal meal, required int usedCntPortion}) async {
    await interactor.updateMeal(meal: meal, usedCntPortion: usedCntPortion);
    await _loadMeals();
  }

  void updateMeals({required Map<String, int> mealsMap}) {
    interactor.updateMeals(mealsMap: mealsMap);
    _loadMeals();
  }

  void addMealByRecipe(Recipe recipe) {
    interactor.addMealByRecipe(recipe);
    _loadMeals();
  }

  Future<void> removeMeal(Meal meal) async {
    await interactor.removeMeal(meal);
    await _loadMeals();
  }
}

final mealRepositoryProvider = Provider((ref) {
  final box = Hive.box<Meal>('MealBox');
  return MealRepository(box);
});

final mealProvider = StateNotifierProvider<MealNotifier, Set<Meal>>((ref) {
  return MealNotifier(
    ref.read(mealRepositoryProvider),
    ref.read(mealInteractorProvider),
  );
});
