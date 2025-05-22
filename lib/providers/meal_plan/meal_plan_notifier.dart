import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/meal_plan.dart';
import 'meal_plan_interactor.dart';

class MealPlanNotifier extends StateNotifier<List<MealPlan>> {
  final MealPlanInteractor interactor;

  MealPlanNotifier(this.interactor) : super(<MealPlan>[]) {
    _loadMealPLan();
  }

  Future<void> _loadMealPLan() async {
    state = await interactor.loadMealPLan();
  }

  Future<void> addPlan(MealPlan plan) async {
    await interactor.addPlan(plan);
    await _loadMealPLan();
  }

  Future<void> removePlanByDate(DateTime date) async {
    await interactor.removePlanByDate(date);
    await _loadMealPLan();
  }

  Future<MealPlan?> getPlanByDate(DateTime date) async =>
      interactor.getPlanByDate(date);

  Future<void> saveMealPlan({
    required DateTime date,
    required Map<String, int> mealCntMap,
  }) async {
    await interactor.saveMealPlan(date: date, mealCntMap: mealCntMap);
    await _loadMealPLan();
  }
}

final mealPlanProvider =
    StateNotifierProvider<MealPlanNotifier, List<MealPlan>>(
      (ref) => MealPlanNotifier(ref.read(mealPlanInteractorProvider)),
    );

final daysPlanProvider = Provider<Map<DateTime, MealPlan>>((ref) {
  final plans = ref.watch(mealPlanProvider);
  return {for (var e in plans) e.date: e};
});
