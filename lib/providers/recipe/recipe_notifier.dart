import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/providers/recipe/recipe_repository.dart';
import '../../models/recipe.dart';

class RecipeNotifier extends StateNotifier<Set<Recipe>> {
  final RecipeRepository repo;

  RecipeNotifier(this.repo) : super(<Recipe>{}) {
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    state = await repo.fetchAllRecipes();
  }

  Future<void> addRecipes(Set<Recipe> recipesFromJson) async {
    final unloadedRecipes = recipesFromJson.where((e) => !state.contains(e));
    await repo.addRecipes(unloadedRecipes);
    await _loadRecipes();
  }

  Future<void> addOrReplaceRecipe(Recipe recipe) async {
    await repo.addOrReplaceRecipe(recipe);
    await _loadRecipes();
  }

  Future<void> removeRecipe(Recipe recipe) async {
    await repo.removeRecipe(recipe);
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

final recipeRepositoryProvider = Provider((ref) {
  final box = Hive.box<Recipe>('recipeBox');
  return RecipeRepository(box);
});

final recipeProvider = StateNotifierProvider<RecipeNotifier, Set<Recipe>>(
        (ref) => RecipeNotifier(ref.read(recipeRepositoryProvider)));
