import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import 'package:my_recipe_app/core/logger.dart';
import '../models/meal_plan.dart';

class MealPlanNotifier extends StateNotifier<List<MealPlan>> {
  final Box<MealPlan> _box;

  MealPlanNotifier(this._box) : super(_box.values.toList());

  void addOrReplacePlan(MealPlan plan) {
    final dateKey = plan.date.dateKey;
    _box.put(dateKey, plan);
    state = _box.values.toList();
  }

  void removePlanByDate(DateTime date) {
    final key = date.dateKey;
    if (_box.get(date.dateKey) != null) {
      _box.delete(key);
      state = _box.values.toList();
    }
  }

  MealPlan? getPlanByDate(DateTime date) {
    final key = date.dateKey;
    return _box.get(key);
  }

  void saveMealPlan({
    required DateTime date,
    required Map<String, int> mealCntMap,
  }) {
    final plan = MealPlan(date: date.dateOnly, mealPortions: mealCntMap);
    addOrReplacePlan(plan);
  }
}

final mealPlanProvider =
    StateNotifierProvider<MealPlanNotifier, List<MealPlan>>((ref) {
      final box = Hive.box<MealPlan>('MealPlanBox');
      return MealPlanNotifier(box);
    });

final weekPlanProvider = Provider<Map<DateTime, MealPlan>>((ref) {
  final plans = ref.watch(mealPlanProvider);
  logger.d("weekPlanProvider plans : ${plans.length}");
  return { for (var e in plans) e.date : e };
});
