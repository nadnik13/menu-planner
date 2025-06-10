import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logger/logger.dart';

import '../../models/meal.dart';
import '../../models/meal_plan.dart';
import '../../models/meal_status_types.dart';
import '../../models/recipe.dart';

Future<void> initializeApp() async {
  await initializeDateFormatting('ru');
  Logger.level = Level.debug;

  await Hive.initFlutter();
  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(MealAdapter());
  Hive.registerAdapter(MealPlanAdapter());
  Hive.registerAdapter(MealStatusTypeAdapter());

  await Hive.openBox<Recipe>('recipeBox');
  await Hive.openBox<Meal>('mealBox');
  await Hive.openBox<MealPlan>('mealPlanBox');
}


Future<void> clean() async {
  await Hive.deleteBoxFromDisk("recipeBox");
  await Hive.deleteBoxFromDisk("mealBox");
  await Hive.deleteBoxFromDisk("mealPlanBox");
}
