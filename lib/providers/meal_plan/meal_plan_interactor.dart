import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import '../../models/meal_plan.dart';
import 'meal_plan_repository.dart';

class MealPlanInteractor {
  final MealPlanRepository repo;

  MealPlanInteractor(this.repo);

  Future<List<MealPlan>> loadMealPLan() async =>
    await repo.fetchAllMealPlans();

  Future<void> addPlan(MealPlan plan) async {
    await repo.addOrReplacePlan(plan);
  }

  Future<void> removePlanByDate(DateTime date) async {
    await repo.removePlanByKey(date.dateKey);
  }

  Future<MealPlan?> getPlanByDate(DateTime date) async =>
      repo.getPlanByKey(date.dateKey);

  Future<void> saveMealPlan({
    required DateTime date,
    required Map<String, int> mealCntMap,
  }) async {
    final plan = MealPlan(date: date.dateOnly, mealPortions: mealCntMap);
    await repo.addOrReplacePlan(plan);
  }
}

final mealPlanRepositoryProvider = Provider((ref) {
  final box = Hive.box<MealPlan>('MealPlanBox');
  return MealPlanRepository(box);
});

final mealPlanInteractorProvider = Provider<MealPlanInteractor>((ref) {
  final repo = ref.watch(mealPlanRepositoryProvider);
  return MealPlanInteractor(repo);
});