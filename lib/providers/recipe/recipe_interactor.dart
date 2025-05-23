import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/core/logger.dart';
import 'package:my_recipe_app/providers/recipe/recipe_json_load_interactor.dart';
import 'package:my_recipe_app/providers/recipe/recipe_notifier.dart';
import 'package:my_recipe_app/providers/recipe/recipe_repository.dart';
import '../../models/recipe.dart';

class RecipeInteractor {
  final RecipeRepository repo;
  final RecipeNotifier notifier;
  final RecipeJsonLoadInteractor jsonInteractor;

  RecipeInteractor(this.repo, this.notifier, this.jsonInteractor);

  Future<void> _addRecipe(Recipe recipe) async {
    await repo.addOrReplaceRecipe(recipe);
    notifier.addOrReplaceRecipe(recipe);
  }

  Future<void> addRecipe({required String title, required int portion}) async {
    final recipeId = notifier.findByTitle(title)?.id;

    final editedRecipe = Recipe.add(
      id: recipeId,
      title: title,
      portion: portion,
    );
    _addRecipe(editedRecipe);
  }

  Future<void> addRecipes(Set<Recipe> newRecipes) async {
    final recipes = notifier.fetchAllRecipes;
    final unloadedRecipes =
        newRecipes.where((e) => !recipes.contains(e)).toSet();
    logger.d(
      "addRecipes: ${recipes.length}/${newRecipes.length}/${unloadedRecipes.length} (old/new/unload)",
    );
    await repo.addRecipes(unloadedRecipes);
    notifier.addRecipes(unloadedRecipes);
  }

  Future<void> loadRecipes() async {
    final recipes = await repo.fetchAllRecipes();

    if (recipes.isEmpty) {
      recipes.addAll(await jsonInteractor.loadFromJson());
    }
    await addRecipes(recipes);
  }

  Future<void> removeRecipe(Recipe recipe) async {
    logger.d("removeRecipe ${recipe.title}");
    await repo.removeRecipe(recipe);
    final recipes = await repo.fetchAllRecipes();

    logger.d("recipes ${recipes.length}");
    await notifier.removeRecipe(recipe);
    logger.d("recipes ${notifier.fetchAllRecipes.length}");
  }
}

final recipeRepositoryProvider = Provider((ref) {
  final box = Hive.box<Recipe>('recipeBox');
  return RecipeRepository(box);
});

final recipeInteractorProvider = Provider<RecipeInteractor>((ref) {
  final repo = ref.watch(recipeRepositoryProvider);
  final notifier = ref.watch(recipeProvider.notifier);
  final jsonInteractor = ref.watch(recipeJsonLoaderInteraptor);
  return RecipeInteractor(repo, notifier, jsonInteractor);
});
