import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/providers/meal_plan/meal_plan_interactor.dart';
import '../meal/meal_interactor.dart';

class MealPlanSaveInteractor {
  final MealPlanInteractor planInteractor;
  final MealInteractor mealInteractor;

  MealPlanSaveInteractor(this.planInteractor, this.mealInteractor);

  Future<void> saveMealPLan({
    required Map<String, int> mealCntMap,
    required Map<String, int> changedMealPortions,
    required DateTime date,
  }) async {
    await mealInteractor.updateMeals(mealsMap: changedMealPortions);
    await planInteractor.saveMealPlan(date: date, mealCntMap: mealCntMap);
  }
}

final mealPlanSaveInteractorProvider = Provider((ref) {
  return MealPlanSaveInteractor(
    ref.read(mealPlanInteractorProvider),
    ref.read(mealInteractorProvider),
  );
});
