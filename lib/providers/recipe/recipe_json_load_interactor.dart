import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/logger.dart';
import '../../models/recipe.dart';
import 'dart:convert';

class RecipeJsonLoadInteractor {
  final AssetBundle bundle;
  RecipeJsonLoadInteractor(this.bundle);

  Future<Set<Recipe>> loadFromJson() async {
    try {
      final jsonString = await bundle.loadString('assets/recipes.json');
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

final recipeJsonLoaderInteraptor = Provider<RecipeJsonLoadInteractor>((ref){
  final bundle = rootBundle;
  return RecipeJsonLoadInteractor(bundle);});