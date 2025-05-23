import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/meal_plan.dart';

class MealPlanNotifier extends StateNotifier<List<MealPlan>> {

  MealPlanNotifier() : super(<MealPlan>[]);

  List<MealPlan> get fetchAllMealPlans => state;

  void loadMealPLan(List<MealPlan> plans) {
    state = plans;
  }

  void addOrReplacePlan(MealPlan plan) {
    state = state.where((e) => e.date != plan.date).toList();
    state = [...state, plan];
  }

  void removePlanByKey(DateTime date) {
    state = state.where((e) => e.date != date).toList();
  }

  MealPlan? getPlanByDate(DateTime date) =>
      state.where((e) => e.date == date).firstOrNull;
}

final mealPlanProvider =
    StateNotifierProvider<MealPlanNotifier, List<MealPlan>>(
      (ref) => MealPlanNotifier(),
    );

final daysPlanProvider = Provider<Map<DateTime, MealPlan>>((ref) {
  final plans = ref.watch(mealPlanProvider);
  return {for (var e in plans) e.date: e};
});
