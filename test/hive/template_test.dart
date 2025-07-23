import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:food_planner/models/dish_template/dish_template.dart';
import 'dart:io';


void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final tempDirectory = Directory.systemTemp.createTempSync();
  Hive.init(tempDirectory.path);
  Hive.registerAdapter(DishTemplateAdapter());
  final box = await Hive.openBox<DishTemplate>('testDishTemplateBox');

  tearDown() async {
    await box.clear();
  }

  test('Добавление и чтение шаблона блюда', () async {
    final title = 'Салат Цезарь';
    final template = DishTemplate.add(title: title, portion: 1);
    await box.add(template);

    final templates = box.values.toList();
    expect(templates.length, 1);
    expect(templates.first.title, template.title);
    tearDown();
  });

  test('Удаление шаблона блюда', () async {
    final title = 'Салат Цезарь';
    final template = DishTemplate.add(title: title, portion: 1);
    await box.put(template.id, template);

    expect(box.length, 1);
    await box.delete(template.id);
    final templates = box.values.toList();
    expect(templates.length, 0);
    tearDown();
  });
}
