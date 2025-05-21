import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import '../../models/meal_plan.dart';
import 'meal_plan_notifier.dart';
import 'meal_plan_repository.dart';

class MealPlanInteractor {
  final MealPlanRepository repo;

  MealPlanInteractor(this.repo);

  Future<void> saveMealPlan({
    required DateTime date,
    required Map<String, int> mealCntMap,
  }) async {
    final plan = MealPlan(date: date.dateOnly, mealPortions: mealCntMap);
    await repo.addOrReplacePlan(plan);
  }
}

final mealPlanInteractorProvider = Provider<MealPlanInteractor>((ref) {
  final repo = ref.watch(mealPlanRepositoryProvider);
  return MealPlanInteractor(repo);
});