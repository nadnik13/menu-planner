import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
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

  Future<Set<DishTemplate>> loadFromFireStore() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('default_dish_templates').get();

    final loaded = <DishTemplate>{};
    for (var doc in snapshot.docs) {
      try {
        final template = DishTemplate.fromJson(doc.data());
        loaded.add(template);
      } catch (e) {
        logger.e('❌ Ошибка при обработке документа ${doc.id}: $e');
      }
    }

    logger.d('🎉 Успешно загружено ${loaded.length} рецептов из firestore');
    return loaded;
  }
}
