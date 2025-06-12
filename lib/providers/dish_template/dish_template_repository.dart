import 'package:hive/hive.dart';
import '../../models/dish_template/dish_template.dart';

class DishTemplateRepository {
  final Box<DishTemplate> _dishTemplateBox;

  DishTemplateRepository(this._dishTemplateBox);

  Future<void> addValues(Set<DishTemplate> templates) async {
    for (final template in templates) {
      _dishTemplateBox.put(template.id, template);
    }
  }

  Future<void> addOrReplace(DishTemplate template) async {
    _dishTemplateBox.put(template.id, template);
  }

  Future<Set<DishTemplate>> fetchAllValues() async {
    return _dishTemplateBox.values.toSet();
  }

  Future<void> remove(DishTemplate template) async {
    await _dishTemplateBox.delete(template.id);
  }
}
