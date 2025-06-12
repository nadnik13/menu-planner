import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/logger.dart';
import '../../models/dish_template.dart';
import 'dish_template_json_load_interactor.dart';
import 'dish_template_notifier.dart';
import 'dish_template_repository.dart';

/// ✅ Interactor остается как есть, только убираем setLoading/setError
class DishTemplateInteractor {
  final DishTemplateNotifier _notifier;
  final DishTemplateRepository _repository;
  final DishTemplateJsonLoadInteractor _jsonInteractor;

  DishTemplateInteractor(this._notifier, this._repository, this._jsonInteractor);

  /// Загрузка шаблонов из Repository
  Future<void> loadTemplates() async {
    try {
      final templates = await _repository.loadTemplates();

      if (templates.isEmpty) {
        templates.addAll(await _jsonInteractor.loadFromJson());
      }
      await addTemplates(templates);
    } catch (e) {
      logger.e('❌ Ошибка загрузки шаблонов: $e');
    }
  }

  Future<void> addTemplates(Set<DishTemplate> newRecipes) async {
    final templates = _notifier.fetchAllTemplates;
    final unloadedTemplates =
    newRecipes.where((e) => !templates.contains(e)).toSet();
    logger.d(
      "addRecipes: ${templates.length}/${newRecipes.length}/${unloadedTemplates.length} (old/new/unload)",
    );
    await _repository.saveTemplates(unloadedTemplates);
    _notifier.addTemplates(unloadedTemplates);
  }



  /// Добавление шаблона
  Future<void> addTemplate(DishTemplate template) async {
    try {
      await _repository.saveTemplate(template);
      await _notifier.addTemplate(template);
    } catch (e) {
      print('❌ Ошибка добавления шаблона: $e');
    }
  }

  /// Удаление шаблона
  Future<void> removeTemplate(DishTemplate template) async {
    try {
      await _repository.deleteTemplate(template);
      await _notifier.removeTemplate(template);
    } catch (e) {
      print('❌ Ошибка удаления шаблона: $e');
    }
  }

  /// Обновление шаблона
  Future<void> updateTemplate(DishTemplate template) async {
    try {
      await _repository.saveTemplate(template);
      await _notifier.addOrReplaceTemplate(template);
    } catch (e) {
      print('❌ Ошибка обновления шаблона: $e');
    }
  }
}

final dishTemplateInteractorProvider = Provider<DishTemplateInteractor>((ref) {
  final repository = ref.watch(dishTemplateRepositoryProvider);
  final notifier = ref.watch(dishTemplateProvider.notifier);
  final jsonInteractor = ref.watch(dishTemplateJsonLoaderInteractor);
  return DishTemplateInteractor(notifier, repository, jsonInteractor);
}); 