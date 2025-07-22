import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/dish_template/dish_template.dart';
import 'dish_template_repository.dart';

class DishTemplateNotifier extends StateNotifier<Set<DishTemplate>> {
  DishTemplateNotifier(this.repo) : super(<DishTemplate>{});
  final DishTemplateRepository repo;

  void loadValues(Set<DishTemplate> templates) {
    state = templates;
  }

  Set<DishTemplate> get fetchAllValues => state;

  Future<void> addValues(Set<DishTemplate> templates) async {
    final unloadedValues = state.where((e) => !state.contains(e)).toSet();
    await repo.addValues(unloadedValues);
    state = {...state, ...templates};
  }

  Future<void> add(DishTemplate template) async {
    state = {...state, template};
  }

  Future<void> remove(String id) async {
    await repo.remove(id);
    state = state.where((e) => e.id != id).toSet();
  }

  Future<void> addOrReplace(DishTemplate template) async {
    await repo.addOrReplace(template);
    final templates = state.where((e) => e.id != template.id).toSet();
    state = {...templates, template};
  }

  DishTemplate? findByTitle(String title) {
    final template = state.firstWhere(
      (e) => e.title == title,
      orElse: () => DishTemplate.empty,
    );
    return template.id.isEmpty ? null : template;
  }
}
