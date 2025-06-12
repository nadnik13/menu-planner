import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/dish_template.dart';

/// ✅ УПРОЩЕННЫЙ StateNotifier - работает с простым Set<DishTemplate>
/// Убираем сложный DishTemplateState, оставляем Repository и Interactor как есть
class DishTemplateNotifier extends StateNotifier<Set<DishTemplate>> {
  DishTemplateNotifier() : super({});

  /// Загрузка шаблонов из Repository
  void loadTemplates(Set<DishTemplate> templates) {
    state = templates;
  }

  /// Получение всех шаблонов
  Set<DishTemplate> get fetchAllTemplates {
    return state;
  }

  /// Добавление нескольких шаблонов
  Future<void> addTemplates(Set<DishTemplate> templates) async {
    state = {...state, ...templates};
  }

  /// Добавление одного шаблона
  Future<void> addTemplate(DishTemplate template) async {
    state = {...state, template};
  }

  /// Удаление шаблона
  Future<void> removeTemplate(DishTemplate template) async {
    state = state.where((e) => e.id != template.id).toSet();
  }

  /// Добавление или замена шаблона
  Future<void> addOrReplaceTemplate(DishTemplate template) async {
    final filteredTemplates = state.where((e) => e.id != template.id).toSet();
    state = {...filteredTemplates, template};
  }

  /// Поиск шаблона по названию
  DishTemplate? findByTitle(String title) {
    try {
      final template = state.firstWhere(
        (e) => e.title == title,
        orElse: () => DishTemplate.empty(),
      );
      return template.id.isEmpty ? null : template;
    } catch (e) {
      return null;
    }
  }

  /// ❌ УБИРАЕМ setLoading и setError - больше не нужны
  /// Простой Set не требует состояний loading/error
}

/// ✅ ПРОСТОЙ провайдер с Set<DishTemplate>
final dishTemplateProvider = StateNotifierProvider<DishTemplateNotifier, Set<DishTemplate>>(
  (ref) => DishTemplateNotifier(),
); 