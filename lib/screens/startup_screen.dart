import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/screens/days_plan_screen.dart';

import '../models/recipe.dart';
import '../providers/recipe/recipe_interactor.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  Future<void> loadRecipes(WidgetRef ref) async {
    final box = Hive.box<Recipe>('recipeBox');

    if (box.isEmpty) {
      await ref.read(recipeInteractorProvider).loadRecipes(ref);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return FutureBuilder(
          future: loadRecipes(ref),
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
              return const WeekPlanScreen(); // основной экран
            }
          },
        );
      },
    );
  }
}
