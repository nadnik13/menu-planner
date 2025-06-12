// import 'package:flutter_test/flutter_test.dart';
// import 'package:my_recipe_app/models/meal.dart';
// import 'package:hive/hive.dart';
// import 'dart:io';
//
// import 'package:my_recipe_app/models/recipe.dart';
//
// void main() async {
//   TestWidgetsFlutterBinding.ensureInitialized();
//
//   final tempDir = Directory.systemTemp.createTempSync();
//   Hive.init(tempDir.path);
//   Hive.registerAdapter(RecipeAdapter());
//   Hive.registerAdapter(MealAdapter());
//   final box = await Hive.openBox<Meal>('testMealBox');
//
//   tearDown() async {
//     await box.clear();
//   }
//
//   test('Добавление блюда', () async {
//     final meal = Meal.add(Recipe.add(title: 'Борщь', portion: 5));
//
//     expect(box.length, 0);
//     await box.add(meal);
//
//     final allMeals = box.values.toList();
//     expect(allMeals.length, 1);
//     expect(allMeals.first, meal);
//     tearDown();
//   });
//
//   test('Удаление блюда', () async {
//     final plan = Meal.add(Recipe.add(title: 'Борщь', portion: 5));
//     final key = await box.add(plan);
//     expect(box.length, 1);
//
//     box.delete(key);
//     final allMeals = box.values.toList();
//     expect(allMeals.length, 0);
//     tearDown();
//   });
// }
