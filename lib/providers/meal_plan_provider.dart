import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/meal_plan.dart';
import '../models/recipe.dart';

class MealPlanNotifier extends StateNotifier<List<MealPlan>> {
  final Box<MealPlan> _box;

  MealPlanNotifier(this._box) : super(_box.values.toList());

  void addPlan(DateTime date, MealPlan plan) {
    final item = getPlanForDate(date);
    print("Title: ${item.recipe.title} (${item.recipe.title.isNotEmpty})");
    if (item.recipe.title.isNotEmpty) {
      removePlan(item);
    }
    _box.add(plan);
    state = _box.values.toList();
  }

  void removePlan(MealPlan plan) {
    print("removePlan");
    final key = _box.keys.firstWhere((k) {
      print(
        '${_box.get(k)?.recipe.title} == ${plan.recipe.title} (${_box.get(k) == plan})',
      );
      print('${_box.get(k)?.date} == ${plan.date} (${_box.get(k) == plan})');
      return _box.get(k) == plan;
    }, orElse: () => null);
    print("removePlan: $key");
    print("state length: ${state.length}");
    if (key != null) {
      _box.delete(key);
      state = _box.values.toList();
    }
    print("state length: ${state.length}");
  }

  MealPlan getPlanForDate(DateTime date) {
    final plan = state.firstWhere(
      (e) =>
          e.date.day == date.day &&
          e.date.month == date.month &&
          e.date.year == date.year,
      orElse: () => MealPlan(date: date, recipe: Recipe('')),
    );
    return plan;
  }

  List<MealPlan> getPlanForWeek() {
    final today = DateTime.now();
    final nextWeek = today.add(Duration(days: 7));
    return state.where((plan) {
        return plan.date.isAfter(today.subtract(const Duration(days: 1))) &&
            plan.date.isBefore(nextWeek);
      }).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }
}

final mealPlanProvider =
    StateNotifierProvider<MealPlanNotifier, List<MealPlan>>((ref) {
      final box = Hive.box<MealPlan>('MealPlanBox');
      return MealPlanNotifier(box);
    });
