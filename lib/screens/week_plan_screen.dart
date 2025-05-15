import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:my_recipe_app/core/extensions/date_extensions.dart';
import 'package:my_recipe_app/models/meal_plan.dart';
import 'package:my_recipe_app/widgets/day_list.dart';
import '../providers/meal_plan_provider.dart';

class WeekPlanScreen extends ConsumerWidget {
  const WeekPlanScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mealPlans = ref.watch(weekPlanProvider);
    final dateKeys = mealPlans.map((e) => e.date).toSet();
    final mealMap = <DateTime, List<MealPlan>>{};


    return Scaffold(
      appBar: AppBar(title: Text('Меню на неделю')),
      body: DayList());
  }
}