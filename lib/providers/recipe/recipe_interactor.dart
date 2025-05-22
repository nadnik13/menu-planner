import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/providers/recipe/recipe_json_load_interactor.dart';
import 'package:my_recipe_app/providers/recipe/recipe_repository.dart';
import '../../models/recipe.dart';

class RecipeInteractor {
  final RecipeRepository repo;
  final RecipeJsonLoadInteractor jsonInteractor;

  RecipeInteractor(this.repo, this.jsonInteractor);

  Future<Set<Recipe>> fetchAllRecipes() async => await repo.fetchAllRecipes();

  Future<void> addRecipe(Recipe recipe) async {
    await repo.addOrReplaceRecipe(recipe);
  }

  Future<void> addRecipes(Set<Recipe> newRecipes) async {
    final recipes = await repo.fetchAllRecipes();
    final unloadedRecipes = newRecipes.where((e) => !recipes.contains(e));
    await repo.addRecipes(unloadedRecipes);
  }

  Future<void> loadRecipesFromJson() async {
    final recipes = await repo.fetchAllRecipes();

    if (recipes.isEmpty) {
      final recipes = await jsonInteractor.loadFromJson();
      await addRecipes(recipes);
    }
  }

  Future<void> removeRecipe(Recipe recipe) async {
    await repo.removeRecipe(recipe);
  }
}

final recipeRepositoryProvider = Provider((ref) {
  final box = Hive.box<Recipe>('recipeBox');
  return RecipeRepository(box);
});

final recipeInteractorProvider = Provider<RecipeInteractor>((ref) {
  final repo = ref.watch(recipeRepositoryProvider);
  final jsonInteractor = ref.watch(recipeJsonLoaderInteraptor);
  return RecipeInteractor(repo, jsonInteractor);
});
