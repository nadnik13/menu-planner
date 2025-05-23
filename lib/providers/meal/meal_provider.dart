import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/meal.dart';

class MealNotifier extends StateNotifier<Set<Meal>> {
  MealNotifier() : super(<Meal>{}) {}

  void addMeals(Set<Meal> meals) {
    state = {...state, ...meals};
  }

  Map<String, String> getTitleMap() => {for (var e in state) e.id: e.title};

  Meal? getMealByKey(String key) => state.where((e) => e.id == key).firstOrNull;

  Set<Meal> getAvailableMeals() => state.where((e) => e.availablePortion > 0).toSet();
  Set<Meal> findByRecipeKey(String recipeKey)
   => state.where((e) => e.recipeId == recipeKey).toSet();


  void addOrReplaceMeal(Meal meal) {
    state = state.where((e) => e.id != e.title).toSet();
    state = {...state, meal};
  }

  void removeMealByKey(String key) {
    state = state.where((e) => e.id != key).toSet();
  }
}

final mealProvider = StateNotifierProvider<MealNotifier, Set<Meal>>((ref) {
  return MealNotifier();
});
