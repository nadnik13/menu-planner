import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/core/logger.dart';
import '../../models/meal_plan.dart';
import 'meal_plan_interactor.dart';
import 'meal_plan_repository.dart';

class MealPlanNotifier extends StateNotifier<List<MealPlan>> {
  final MealPlanRepository repo;
  final MealPlanInteractor interactor;

  MealPlanNotifier(this.repo, this.interactor) : super(<MealPlan>[]) {
    _loadMealPLan();
  }

  Future<void> _loadMealPLan() async {
    state = await repo.fetchAllMealPlans();
  }

  Future<void> addOrReplacePlan(MealPlan plan) async {
    await repo.addOrReplacePlan(plan);
    await _loadMealPLan();
  }

  Future<void> removePlanByDate(DateTime date) async {
    await repo.removePlanByDate(date);
    await _loadMealPLan();
  }

  Future<MealPlan?> getPlanByDate(DateTime date) async =>
      repo.getPlanByDate(date);

  Future<void> saveMealPlan({
    required DateTime date,
    required Map<String, int> mealCntMap,
  }) async {
    await interactor.saveMealPlan(date: date, mealCntMap: mealCntMap);
    await _loadMealPLan();
  }
}

final mealPlanRepositoryProvider = Provider((ref) {
  final box = Hive.box<MealPlan>('MealPlanBox');
  return MealPlanRepository(box);
});
final mealPlanProvider =
    StateNotifierProvider<MealPlanNotifier, List<MealPlan>>(
      (ref) => MealPlanNotifier(
        ref.read(mealPlanRepositoryProvider),
        ref.read(mealPlanInteractorProvider),
      ),
    );

final weekPlanProvider = Provider<Map<DateTime, MealPlan>>((ref) {
  final plans = ref.watch(mealPlanProvider);
  logger.d("weekPlanProvider plans : ${plans.length}");
  return {for (var e in plans) e.date: e};
});
