import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  RecipeNotifier() : super([]);

  void addRecipe(String title) {
    final recipe = Recipe(title);
    state = [...state, recipe];
  }

  void removeRecipe(Recipe recipe) {
    state = state.where((r) => r != recipe).toList();
  }
}

final recipeProvider = StateNotifierProvider<RecipeNotifier, List<Recipe>>(
  (ref) => RecipeNotifier(),
);
