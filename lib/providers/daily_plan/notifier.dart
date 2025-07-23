import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_planner/core/extensions/date_extensions.dart';
import '../../models/daily_plan/daily_plan.dart';
import 'repository.dart';

class DailyPlanNotifier extends StateNotifier<List<DailyPlan>> {
  DailyPlanNotifier(this._repository) : super(<DailyPlan>[]);
  final DailyPlanRepository _repository;

  List<DailyPlan> get fetchAllMealPlans => state;

  Future<void> loadValues() async {
    final plans = await _repository.fetchAllValues();
    state = plans;
  }

  Future<void> addOrReplace(DailyPlan plan) async {
    await _repository.addOrReplace(plan);
    state = state.where((e) => e.date != plan.date).toList();
    state = [...state, plan];
  }

  Future<void> removeByKey(DateTime date) async {
    await _repository.removeByKey(date.dateKey);
    state = state.where((e) => e.date != date).toList();
  }

  Future<void> removeMealFromPlans(String mealId) async {
    final plans = fetchAllMealPlans;
    for (final plan in plans) {
      if (plan.portions.containsKey(mealId)) {
        plan.portions.remove(mealId);
        if (plan.portions.isEmpty) {
          await _repository.removeByKey(plan.date.dateKey);
        } else {
          await _repository.addOrReplace(plan);
        }
        addOrReplace(plan);
      }
    }
  }

  DailyPlan? getByDate(DateTime date) {
    final plan =  state
        .where((e) => e.date == date)
        .firstOrNull;
    return plan;
  }

  int cntPlansOnFuture() =>
      state.where((e) => e.date.isAfter(DateTime.now())).length;
}