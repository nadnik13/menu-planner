import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/recipe.dart';

class RecipeNotifier extends StateNotifier<Set<Recipe>> {
  RecipeNotifier() : super(<Recipe>{});

  void loadRecipes(Set<Recipe> recipes) {
    state = recipes;
  }

  Set<Recipe> get fetchAllRecipes => state;

  Future<void> addRecipes(Set<Recipe> recipes) async {
    state = {...state, ...recipes};
  }

  Future<void> addRecipe(Recipe recipe) async {
    state = {...state, recipe};
  }


  Future<void> removeRecipe(Recipe recipe) async {
    state = state.where((e) => e.id != recipe.id).toSet();
  }

  Future<void> addOrReplaceRecipe(Recipe recipe) async {
    final recipes = state.where((e) => e.id != recipe.id).toSet();
    state = {...recipes, recipe};
  }

  Recipe? findByTitle(String title) {
    final recipe = state.firstWhere(
          (e) => e.title == title,
      orElse: () => Recipe.empty,
    );
    return recipe.id.isEmpty ? null : recipe;
  }
}

final recipeProvider = StateNotifierProvider<RecipeNotifier, Set<Recipe>>(
      (ref) => RecipeNotifier(),
);
