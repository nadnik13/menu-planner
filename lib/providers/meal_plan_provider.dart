import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import 'package:my_recipe_app/models/recipe.dart';
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

  void saveRecipe(DateTime date, Recipe? recipe) {
    if (recipe != null) {
      addOrReplacePlan(MealPlan(date: date, recipe: recipe));
    }
  }
}

final mealPlanProvider =
    StateNotifierProvider<MealPlanNotifier, List<MealPlan>>((ref) {
      final box = Hive.box<MealPlan>('MealPlanBox');
      return MealPlanNotifier(box);
    });

final weekPlanProvider = Provider<List<MealPlan>>((ref) {
  final plans = ref.watch(mealPlanProvider);
  final today = DateTime.now();
  final nextWeek = today.add(Duration(days: 7));
  return plans.where((plan) {
      return plan.date.isAfter(today.subtract(const Duration(days: 1))) &&
          plan.date.isBefore(nextWeek);
    }).toList()
    ..sort((a, b) => a.date.compareTo(b.date));
});
