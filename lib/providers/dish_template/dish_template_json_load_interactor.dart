import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/logger.dart';
import '../../models/dish_template/dish_template.dart';
import 'dart:convert';

class DishTemplateJsonLoadInteractor {
  final AssetBundle bundle;
  DishTemplateJsonLoadInteractor(this.bundle);

  Future<Set<DishTemplate>> loadFromJson() async {
    try {
      final jsonString = await bundle.loadString('assets/templates.json');
      final List<dynamic> jsonList = json.decode(jsonString);
      final loaded = jsonList.map((e) => DishTemplate.fromJson(e)).toSet();
      logger.d('Загружено ${loaded.length} рецептов из assets');
      return loaded;
    } catch (e, st) {
      logger.d('❌ Ошибка при загрузке рецептов: $e');
      logger.d(st);
      return {};
    }
  }
}

final dishTemplateJsonLoaderInteraptor = Provider<DishTemplateJsonLoadInteractor>((ref){
  final bundle = rootBundle;
  return DishTemplateJsonLoadInteractor(bundle);});