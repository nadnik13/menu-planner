import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/providers/meal/meal_interactor.dart';
import 'package:my_recipe_app/providers/meal_plan/meal_plan_interactor.dart';
import 'package:my_recipe_app/screens/days_plan_screen.dart';

import '../providers/recipe/recipe_interactor.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  Future<void> loadData(WidgetRef ref) async {
    await ref.read(recipeInteractorProvider).loadRecipes();
    await ref.read(mealInteractorProvider).loadMeals();
    await ref.read(mealPlanInteractorProvider).loadMealPLan();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return FutureBuilder(
          future: loadData(ref),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError) {
              return Scaffold(
                body: Center(child: Text('Ошибка: ${snapshot.error}')),
              );
            } else {
              return const DaysPlanScreen(); // основной экран
            }
          },
        );
      },
    );
  }
}
