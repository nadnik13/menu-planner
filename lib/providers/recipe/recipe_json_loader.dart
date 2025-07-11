import 'package:flutter/services.dart';
import '../../core/logger.dart';
import '../../models/recipe.dart';
import 'dart:convert';

class RecipeJsonLoader {
  RecipeJsonLoader();

  static Future<Set<Recipe>> loadFromJson() async {
    try {
      final jsonString = await rootBundle.loadString('assets/recipes.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final loadedRecipes = jsonList.map((e) => Recipe.fromJson(e)).toSet();
      logger.d('Загружено ${loadedRecipes.length} рецептов из assets');
      return loadedRecipes;
    } catch (e, st) {
      logger.d('❌ Ошибка при загрузке рецептов: $e');
      logger.d(st);
      return {};
    }
  }
}