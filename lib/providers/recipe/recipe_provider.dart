import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/recipe.dart';

class RecipeNotifier extends StateNotifier<Set<Recipe>> {
  final Box<Recipe> _box;

  RecipeNotifier(this._box) : super(_box.values.toSet());

  void addRecipes(Set<Recipe> recipesFromJson) {
    final unloadedRecipes = recipesFromJson.where((e) => !state.contains(e));
    for (final recipe in unloadedRecipes) {
      _box.put(recipe.id, recipe);
    }
    state = _box.values.toSet();
  }

  void addOrReplaceRecipe(Recipe recipe) {
    _box.put(recipe.id, recipe);
    state = _box.values.toSet();
  }

  void loadFromBox() {
    state = _box.values.toSet();
  }

  void removeRecipe(Recipe recipe) {
    _box.delete(recipe.id);
    state = _box.values.toSet();
  }

  Recipe? findByTitle(String title) {
    final recipe = state.firstWhere(
      (e) => e.title == title,
      orElse: () => Recipe.empty,
    );
    return recipe.id.isEmpty ? null : recipe;
  }
}

final recipeProvider = StateNotifierProvider<RecipeNotifier, Set<Recipe>>((
  ref,
) {
  final box = Hive.box<Recipe>('RecipeBox');
  return RecipeNotifier(box);
});
