import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/screens/recipes_screen.dart';

import '../models/recipe.dart';
import '../providers/recipe/recipe_loader_provider.dart';
import '../providers/recipe/recipe_provider.dart';

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
              return const RecipeScreen(); // основной экран
            }
          },
        );
      },
    );
  }
}
