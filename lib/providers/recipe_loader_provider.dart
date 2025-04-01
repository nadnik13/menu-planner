import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/recipe.dart';
import 'dart:convert';

final recipeLoaderProvider = FutureProvider<List<Recipe>>(
    (ref) async {
      final jsonString = await rootBundle.loadString('assets/recipes.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((e) => Recipe.fromJson(e)).toList();
    }
);
