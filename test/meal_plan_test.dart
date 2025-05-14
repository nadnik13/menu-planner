import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_app/models/meal.dart';
import 'package:my_recipe_app/models/meal_plan.dart';
import 'package:hive/hive.dart';
import 'dart:io';

import 'package:my_recipe_app/models/recipe.dart';
import 'package:uuid/uuid.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final uuid = Uuid();
  final tempDir = Directory.systemTemp.createTempSync();
  Hive.init(tempDir.path);
  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(MealPlanAdapter());
  final box = await Hive.openBox<MealPlan>('testMealPlanBox');

  tearDown() async {
    await box.clear();
  }

  test('Добавление плана', () async {
    final plan = MealPlan(
      date: DateTime.now(),
      meal: Meal.add(Recipe.add('Борщь', '', 5)),
      portion: 2,
    );

    expect(box.length, 0);
    await box.add(plan);

    final allMealPlans = box.values.toList();
    expect(allMealPlans.length, 1);
    expect(allMealPlans.first, plan);
    tearDown();
  });

  test('Удаление плана', () async {
    final id = uuid.v4();
    final plan = MealPlan(
      date: DateTime.now(),
      meal: Meal.add(Recipe(id, 'Борщь', 'суп', 5)),
      portion: 1,
    );
    final key = await box.add(plan);
    expect(box.length, 1);
    final date = DateTime.now();

    print('Date: ${DateTime(date.year, date.month, date.day).toString()}');
    box.delete(key);
    final allMealPlans = box.values.toList();
    expect(allMealPlans.length, 0);
    tearDown();
  });
}
