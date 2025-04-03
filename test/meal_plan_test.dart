import 'package:flutter_test/flutter_test.dart';
import 'package:my_recipe_app/models/meal_plan.dart';
import 'package:hive/hive.dart';
import 'dart:io';

import 'package:my_recipe_app/models/recipe.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final tempDir = Directory.systemTemp.createTempSync();
  Hive.init(tempDir.path);
  Hive.registerAdapter(RecipeAdapter());
  Hive.registerAdapter(MealPlanAdapter());
  final box = await Hive.openBox<MealPlan>('testMealPlanBox');

  tearDown() async {
    await box.clear();
  }

  test('Добавление плана', () async {
    final plan = MealPlan(date: DateTime.now(), recipe: Recipe('Борщь'));
    expect(box.length, 0);
    await box.add(plan);

    final allMealPlans = box.values.toList();
    expect(allMealPlans.length, 1);
    expect(allMealPlans.first, plan);
    tearDown();
  });

  test('Удаление плана', () async {
    final plan = MealPlan(date: DateTime.now(), recipe: Recipe('Борщь'));
    final id = await box.add(plan);
    expect(box.length, 1);

    box.delete(id);
    final allMealPlans = box.values.toList();
    expect(allMealPlans.length, 0);
    tearDown();
  });
}
