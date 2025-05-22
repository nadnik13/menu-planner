import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/providers/recipe/recipe_interactor.dart';
import '../../models/recipe.dart';

class RecipeNotifier extends StateNotifier<Set<Recipe>> {
  final RecipeInteractor interactor;

  RecipeNotifier(this.interactor) : super(<Recipe>{}) {
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    state = await interactor.fetchAllRecipes();
  }

  Future<void> addRecipes(Set<Recipe> recipesFromJson) async {
    await interactor.addRecipes(recipesFromJson);
    await _loadRecipes();
  }

  Future<void> addRecipe(Recipe recipe) async {
    await interactor.addRecipe(recipe);
    await _loadRecipes();
  }

  Future<void> removeRecipe(Recipe recipe) async {
    await interactor.removeRecipe(recipe);
    await _loadRecipes();
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
  (ref) => RecipeNotifier(ref.read(recipeInteractorProvider)),
);
