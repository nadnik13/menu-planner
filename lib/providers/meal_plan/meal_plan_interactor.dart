import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import 'package:my_recipe_app/providers/meal_plan/meal_plan_notifier.dart';
import '../../models/meal_plan.dart';
import 'meal_plan_repository.dart';

class MealPlanInteractor {
  final MealPlanRepository repo;
  final MealPlanNotifier notifier;

  MealPlanInteractor(this.repo, this.notifier);

  Future<void> loadMealPLan() async {
    final plans = await repo.fetchAllMealPlans();
    notifier.loadMealPLan(plans);
  }

  int getCntPlans() => notifier.cntPlansOnFuture();

  Future<void> addPlan(DateTime date, Map<String, int> mealPortions) async {
    final plan = MealPlan(date: date.dateOnly, mealPortions: mealPortions);
    await repo.addOrReplacePlan(plan);
    notifier.addOrReplacePlan(plan);
  }

  Future<void> removePlanByDate(DateTime date) async {
    await repo.removePlanByKey(date.dateKey);
    notifier.removePlanByKey(date);
  }

  Future<void> removeMealFromPlans(String mealId) async {
    final plans = notifier.fetchAllMealPlans;
    for (final plan in plans) {
      if (plan.mealPortions.containsKey(mealId)) {
        plan.mealPortions.remove(mealId);
        await repo.addOrReplacePlan(plan);
        notifier.addOrReplacePlan(plan);
      }
    }
  }

  MealPlan getPlanByDate(DateTime date) =>
      notifier.getPlanByDate(date) ?? MealPlan(date: date, mealPortions: {});

  Future<void> saveMealPlan({
    required DateTime date,
    required Map<String, int> mealCntMap,
  }) async {
    final plan = MealPlan(date: date, mealPortions: mealCntMap);
    await repo.addOrReplacePlan(plan);
    notifier.addOrReplacePlan(plan);
  }
}

final mealPlanRepositoryProvider = Provider((ref) {
  final box = Hive.box<MealPlan>('MealPlanBox');
  return MealPlanRepository(box);
});

final mealPlanInteractorProvider = Provider<MealPlanInteractor>((ref) {
  final repo = ref.watch(mealPlanRepositoryProvider);
  final notifier = ref.watch(mealPlanProvider.notifier);
  return MealPlanInteractor(repo, notifier);
});
