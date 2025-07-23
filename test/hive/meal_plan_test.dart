import 'package:flutter_test/flutter_test.dart';
import 'package:food_planner/core/extensions/date_extensions.dart';
import 'package:food_planner/models/dish_stock/dish_stock.dart';
import 'package:food_planner/models/daily_plan/daily_plan.dart';
import 'package:hive/hive.dart';
import 'dart:io';

import 'package:food_planner/models/dish_template/dish_template.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final tempDir = Directory.systemTemp.createTempSync();
  Hive.init(tempDir.path);
  Hive.registerAdapter(DishTemplateAdapter());
  Hive.registerAdapter(DailyPlanAdapter());
  final box = await Hive.openBox<DailyPlan>('testMealPlanBox');

  tearDown() async {
    await box.clear();
  }

  test('Добавление плана', () async {
    final meal = DishStock.add(DishTemplate.add(title: 'Борщ', portion: 5));
    final plan = DailyPlan(date: DateTime.now(), portions: {meal.id: 2});

    expect(box.length, 0);
    await box.put(plan.date.dateKey, plan);

    final allMealPlans = box.values.toList();
    expect(allMealPlans.length, 1);
    expect(allMealPlans.first, plan);
    tearDown();
  });

  test('Удаление плана', () async {
    final meal = DishStock.add(DishTemplate.add(title: 'Борщ', portion: 5));
    final plan = DailyPlan(date: DateTime.now(), portions: {meal.id: 1});

    await box.put(plan.date.dateKey, plan);
    expect(box.length, 1);
    box.delete(plan.date.dateKey);
    final allMealPlans = box.values.toList();
    expect(allMealPlans.length, 0);
    tearDown();
  });
}
