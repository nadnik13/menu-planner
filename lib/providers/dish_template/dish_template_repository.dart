import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../models/dish_template.dart';
import '../../core/hive_box_names.dart';

class DishTemplateRepository {
  final Box<DishTemplate> _box;

  DishTemplateRepository(this._box);

  Future<Set<DishTemplate>> loadTemplates() async {
    return _box.values.toSet();
  }
  Future<void> saveTemplates(Set<DishTemplate> templates) async {
    for (final template in templates) {
      _box.put(template.id, template);
    }
  }

  Future<void> saveTemplate(DishTemplate template) async {
    await _box.put(template.id, template);
  }

  Future<void> deleteTemplate(DishTemplate template) async {
    await _box.delete(template.id);
  }
}

final dishTemplateRepositoryProvider = Provider<DishTemplateRepository>((ref) {
  final box = Hive.box<DishTemplate>(HiveBoxNames.dishTemplate);
  return DishTemplateRepository(box);
}); 