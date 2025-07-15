import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:my_recipe_app/core/logger.dart';
import 'package:my_recipe_app/providers/dish_template/dish_template_json_load_interactor.dart';
import 'package:my_recipe_app/providers/dish_template/dish_template_notifier.dart';
import 'package:my_recipe_app/providers/dish_template/dish_template_repository.dart';
import '../../models/dish_template/dish_template.dart';

class DishTemplateInteractor {
  final DishTemplateRepository repo;
  final DishTemplateNotifier notifier;
  final DishTemplateJsonLoadInteractor jsonInteractor;

  DishTemplateInteractor(this.repo, this.notifier, this.jsonInteractor);

  Future<void> _add(DishTemplate template) async {
    await repo.addOrReplace(template);
    notifier.addOrReplace(template);
  }

  Future<void> add({required String title, required int portion}) async {
    final templateId = notifier.findByTitle(title)?.id;

    final edited = DishTemplate.add(
      id: templateId,
      title: title,
      portion: portion,
    );
    _add(edited);
  }

  Future<void> addValues(Set<DishTemplate> newValues) async {
    final values = notifier.fetchAllValues;
    final unloadedValues =
        newValues.where((e) => !values.contains(e)).toSet();
    logger.d(
      "addValues: ${values.length}/${newValues.length}/${unloadedValues.length} (old/new/unload)",
    );
    await repo.addValues(unloadedValues);
    notifier.addValues(unloadedValues);
  }

  Future<void> load() async {
    final templates = await repo.fetchAllValues();

    if (templates.isEmpty) {
      templates.addAll(await jsonInteractor.loadFromJson());
    }
    await addValues(templates);
  }

  Future<void> remove(DishTemplate template) async {
    logger.d("removeTemplate ${template.title}");
    await repo.remove(template);
    final values = await repo.fetchAllValues();

    logger.d("templates ${values.length}");
    await notifier.remove(template);
    logger.d("templates ${notifier.fetchAllValues.length}");
  }
}

final dishTemplateRepositoryProvider = Provider((ref) {
  final box = Hive.box<DishTemplate>('dishTemplateBox');
  return DishTemplateRepository(box);
});

final dishTemplateInteractorProvider = Provider<DishTemplateInteractor>((ref) {
  final repo = ref.watch(dishTemplateRepositoryProvider);
  final notifier = ref.watch(dishTemplateProvider.notifier);
  final jsonInteractor = ref.watch(dishTemplateJsonLoaderInteraptor);
  return DishTemplateInteractor(repo, notifier, jsonInteractor);
});
