import 'package:hive/hive.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import '../../models/meal_plan.dart';

class MealPlanRepository {
  final Box<MealPlan> _box;

  MealPlanRepository(this._box);

  Future<void> addOrReplacePlan(MealPlan plan) async {
    final dateKey = plan.date.dateKey;
    await _box.put(dateKey, plan);
  }

  Future<List<MealPlan>> fetchAllMealPlans() async => _box.values.toList();

  Future<void> removePlanByKey(String key) async {
    if (_box.containsKey(key)) {
      await _box.delete(key);
    }
  }

  Future<MealPlan?> getPlanByKey(String key) async => _box.get(key);
}
