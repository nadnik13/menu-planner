import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/logger.dart';
import '../../models/dish_template.dart';
import 'dart:convert';

class DishTemplateJsonLoadInteractor {
  final AssetBundle bundle;
  DishTemplateJsonLoadInteractor(this.bundle);

  Future<Set<DishTemplate>> loadFromJson() async {
    try {
      final jsonString = await bundle.loadString('assets/templates.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final loadedTemplates = jsonList.map((e) => DishTemplate.fromJson(e)).toSet();
      logger.d('Загружено ${loadedTemplates.length} шаблонов блюд из assets');
      return loadedTemplates;
    } catch (e, st) {
      logger.d('❌ Ошибка при загрузке шаблонов блюд: $e');
      logger.d(st);
      return {};
    }
  }
}

final dishTemplateJsonLoaderInteractor = Provider<DishTemplateJsonLoadInteractor>((ref) {
  final bundle = rootBundle;
  return DishTemplateJsonLoadInteractor(bundle);
});