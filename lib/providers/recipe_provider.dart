import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';

class RecipeNotifier extends StateNotifier<Set<Recipe>> {
  final Box<Recipe> _box;
  RecipeNotifier(this._box) : super(_box.values.toSet());

  Future<void> loadFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/recipes.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    final recipesFromJson = jsonList.map((e) => Recipe.fromJson(e));

    final unloadedRecipes = recipesFromJson.where((e) => !state.contains(e));
    _box.addAll(unloadedRecipes);
    state = _box.values.toSet();
  }

  void addRecipe(String title) {

    final id = DateTime.now().millisecondsSinceEpoch;
    final recipe = Recipe(id, title);

    _box.add(recipe);
    state = _box.values.toSet();
  }

  void addOrReplaceRecipe(Recipe recipe) {
    _box.put(recipe.id, recipe);
    state = _box.values.toSet();
  }

  void removeRecipe(Recipe recipe) {
    _box.delete(recipe);
    final key = _box.keys.firstWhere((k) => _box.get(k) == recipe
        , orElse: () => null);
    _box.delete(key);
    state = _box.values.toSet();

  }
}

final recipeProvider = StateNotifierProvider<RecipeNotifier, Set<Recipe>>(
    (ref) {
      final box = Hive.box<Recipe>('RecipeBox');
      return RecipeNotifier(box);
    }
);
