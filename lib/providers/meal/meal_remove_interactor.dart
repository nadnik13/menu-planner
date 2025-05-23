import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/providers/meal_plan/meal_plan_interactor.dart';
import '../../models/meal.dart';
import 'meal_interactor.dart';

class MealRemoveInteractor {
  final MealInteractor mealInteractor;
  final MealPlanInteractor planInteractor;

  MealRemoveInteractor(this.mealInteractor, this.planInteractor);


  Future<void> removeMeal(Meal meal) async {
    final key = meal.id;
    await mealInteractor.removeMealByKey(key);
    await planInteractor.removeMealFromPlans(key);
  }
}

final mealRemoveInteractorProvider = Provider((ref) {
  return MealRemoveInteractor(
    ref.read(mealInteractorProvider),
    ref.read(mealPlanInteractorProvider),
  );
});
