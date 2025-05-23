import 'package:hive/hive.dart';
import '../../models/recipe.dart';

class RecipeRepository {
  final Box<Recipe> _recipeBox;

  RecipeRepository(this._recipeBox);

  Future<void> addRecipes(Set<Recipe> recipes) async {
    for (final recipe in recipes) {
      _recipeBox.put(recipe.id, recipe);
    }
  }

  Future<void> addOrReplaceRecipe(Recipe recipe) async {
    _recipeBox.put(recipe.id, recipe);
  }

  Future<Set<Recipe>> fetchAllRecipes() async {
    return _recipeBox.values.toSet();
  }

  Future<void> removeRecipe(Recipe recipe) async {
    await _recipeBox.delete(recipe.id);
  }
}
