import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/recipe.dart';
import '../providers/recipe/recipe_json_loader.dart';
import '../providers/recipe/recipe_provider.dart';
import 'meal_screen.dart';

class StartupScreen extends StatelessWidget {
  const StartupScreen({super.key});

  Future<void> loadAndSaveRecipes(WidgetRef ref) async {
    final box = Hive.box<Recipe>('recipeBox');

    if (box.isEmpty) {
      final recipes = await RecipeJsonLoader.loadFromJson();
      Future.microtask(() {
        ref.read(recipeProvider.notifier).addRecipes(recipes);
      });
    } else {
      Future.microtask(() {
        ref.read(recipeProvider.notifier).loadFromBox();
      });
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        return FutureBuilder(
          future: loadAndSaveRecipes(ref),
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
              return const MealScreen(); // основной экран
            }
          },
        );
      },
    );
  }
}
