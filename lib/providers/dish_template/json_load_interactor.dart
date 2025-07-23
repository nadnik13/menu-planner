import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../../core/services/logger.dart';
import '../../models/dish_template/dish_template.dart';

class DishTemplateLoadInteractor {
  final AssetBundle bundle;

  DishTemplateLoadInteractor(this.bundle);

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
