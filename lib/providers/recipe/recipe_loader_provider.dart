import 'package:flutter/services.dart';
import '../../models/recipe.dart';
import 'dart:convert';

class RecipeJsonLoader {
  RecipeJsonLoader();

  static Future<Set<Recipe>> loadFromJson() async {
    final jsonString = await rootBundle.loadString('assets/recipes.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    final loadedRecipes = jsonList.map((e) => Recipe.fromJson(e)).toSet();
    return loadedRecipes;
  }
}
