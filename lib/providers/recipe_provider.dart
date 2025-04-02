import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';

class RecipeNotifier extends StateNotifier<List<Recipe>> {
  RecipeNotifier() : super([]);

  Future<void> loadFromAssets() async {
    final jsonString = await rootBundle.loadString('assets/recipes.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    state = jsonList.map((e) => Recipe.fromJson(e)).toList();
  }

  void addRecipe(String title) {
    final recipe = Recipe(title);
    state = [...state, recipe];
  }

  void addRecipes(List<Recipe> recipes) {
    //TODO нужно ли делать более безопасно как сверху через создание нового списка
    state.addAll(recipes);
  }

  void removeRecipe(Recipe recipe) {
    state = state.where((r) => r != recipe).toList();
  }
}

final recipeProvider = StateNotifierProvider<RecipeNotifier, List<Recipe>>(
  (ref) => RecipeNotifier(),
);
