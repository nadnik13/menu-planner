import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/dish_template/dish_template.dart';

class DishTemplateNotifier extends StateNotifier<Set<DishTemplate>> {
  DishTemplateNotifier() : super(<DishTemplate>{});

  void loadValues(Set<DishTemplate> templates) {
    state = templates;
  }

  Set<DishTemplate> get fetchAllValues => state;

  Future<void> addValues(Set<DishTemplate> templates) async {
    state = {...state, ...templates};
  }

  Future<void> add(DishTemplate template) async {
    state = {...state, template};
  }


  Future<void> remove(String id) async {
    state = state.where((e) => e.id != id).toSet();
  }

  Future<void> addOrReplace(DishTemplate template) async {
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

final dishTemplateProvider = StateNotifierProvider<DishTemplateNotifier, Set<DishTemplate>>(
      (ref) => DishTemplateNotifier(),
);
