import 'package:flutter_test/flutter_test.dart';
import 'package:food_planner/models/dish_stock/dish_stock.dart';
import 'package:food_planner/models/dish_stock/dish_stock_status_types.dart';
import 'package:hive/hive.dart';
import 'dart:io';

import 'package:food_planner/models/dish_template/dish_template.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final tempDir = Directory.systemTemp.createTempSync();
  Hive.init(tempDir.path);
  Hive.registerAdapter(DishTemplateAdapter());
  Hive.registerAdapter(DishStockAdapter());
  Hive.registerAdapter(DishStockStatusTypeAdapter());
  final box = await Hive.openBox<DishStock>('testMealBox');

  tearDown() async {
    await box.clear();
  }

  test('Добавление блюда', () async {
    final meal = DishStock.add(DishTemplate.add(title: 'Борщь', portion: 5));

    expect(box.length, 0);
    await box.add(meal);

    final allMeals = box.values.toList();
    expect(allMeals.length, 1);
    expect(allMeals.first, meal);
    tearDown();
  });

  test('Удаление блюда', () async {
    final plan = DishStock.add(DishTemplate.add(title: 'Борщь', portion: 5));
    await box.put(plan.id, plan);
    expect(box.length, 1);

    box.delete(plan.id);
    final allMeals = box.values.toList();
    expect(allMeals.length, 0);
    tearDown();
  });
}
