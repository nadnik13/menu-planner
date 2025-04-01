import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal_plan.dart';
import '../models/recipe.dart';

class MealPlanNotifier extends StateNotifier<List<MealPlan>> {
  MealPlanNotifier() : super([]);

  void addPlan(DateTime date, MealPlan plan) {
    state = [...state.where((e) => e.date != date), plan];
  }

  MealPlan getPlanForDate(DateTime date) {
    final plan = state.firstWhere(
      (e) => e.date == date, //там сравнение по дням месяцаам году
      orElse: () => MealPlan(date: date, recipe: Recipe('')),
    );
    return plan;
  }
}

final mealPlanProvider = StateNotifierProvider<MealPlanNotifier, List<MealPlan>>(
  (ref) => MealPlanNotifier());