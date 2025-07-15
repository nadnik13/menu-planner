import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:my_recipe_app/models/dish_template/dish_template.dart';
import 'dart:io';

import 'package:uuid/uuid.dart';

void main() async{

  TestWidgetsFlutterBinding.ensureInitialized();

  final tempDirectory = Directory.systemTemp.createTempSync();
  Hive.init(tempDirectory.path);
  Hive.registerAdapter(DishTemplateAdapter());
  final box = await Hive.openBox<DishTemplate>('testRecipeBox');

  tearDown() async{
    await box.clear();
  }

  test('Добавление и чтение рецепта', () async{
    final title = 'Салат Цезарь';
    final recipe = DishTemplate.add(title: title, portion: 1);
    await box.add(recipe);

    final allRecipes = box.values.toList();
    expect(allRecipes.length, 1);
    expect(allRecipes.first.title, recipe.title);
    tearDown();
  });

  test('Удаление рецепта', () async{
    final id = Uuid().v4();
    expect(box.length, 1);
    await box.delete(id);
    final allRecipes = box.values.toList();
    expect(allRecipes.length, 0);
    tearDown();
  });
}
