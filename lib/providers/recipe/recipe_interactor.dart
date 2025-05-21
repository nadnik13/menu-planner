import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/providers/recipe/recipe_json_load_interactor.dart';
import 'package:my_recipe_app/providers/recipe/recipe_notifier.dart';
import 'package:my_recipe_app/providers/recipe/recipe_repository.dart';
import '../../models/recipe.dart';

class RecipeInteractor{
  final RecipeRepository repo;

  RecipeInteractor(this.repo);

  Future<void> addRecipes(Set<Recipe> newRecipes) async{
    final recipes = await repo.fetchAllRecipes();
    final unloadedRecipes = newRecipes.where((e) => !recipes.contains(e));
    await repo.addRecipes(unloadedRecipes);
  }

  Future<void> loadRecipes(WidgetRef ref) async {
    final recipes = await repo.fetchAllRecipes();

      if (recipes.isEmpty) {
        final recipes = await ref.read(recipeJsonLoaderInteraptor).loadFromJson();
        await ref.read(recipeInteractorProvider).addRecipes(recipes);
      }
    }
}

final recipeInteractorProvider = Provider<RecipeInteractor>((ref) {
  final repo = ref.watch(recipeRepositoryProvider);
  return RecipeInteractor(repo);
});