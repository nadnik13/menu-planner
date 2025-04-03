import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_recipe_app/screens/recipe_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/meal_plan.dart';
import 'models/recipe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(MealPlanAdapter());
  await Hive.openBox<Recipe>('recipeBox');
  await Hive.openBox<MealPlan>('mealPlanBox');
  runApp(const ProviderScope(child: MyApp()));
}

final counterProvider = StateProvider<int>((ref) => 0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Счетчик на Riverpod',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const RecipeScreen(),
    );
  }
}