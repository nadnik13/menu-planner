import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:food_planner/core/logger.dart';
import 'package:food_planner/providers/dish_template/dish_template_json_load_interactor.dart';
import 'package:food_planner/providers/dish_template/dish_template_provider.dart';
import 'package:food_planner/providers/dish_template/dish_template_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<void> replace({
    required String id,
    required String title,
    required int portion,
  }) async {
    remove(id);
    final edited = DishTemplate.add(title: title, portion: portion);
    _add(edited);
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

  Future<void> addOrReplace({
    String? id,
    required String title,
    required int portion,
  }) async {
    if (id != null) {
      replace(id: id, title: title, portion: portion);
    } else {
      add(title: title, portion: portion);
    }
  }

  Future<void> addValues(Set<DishTemplate> newValues) async {
    final values = notifier.fetchAllValues;
    final unloadedValues = newValues.where((e) => !values.contains(e)).toSet();
    logger.d(
      "addValues: ${values.length}/${newValues.length}/${unloadedValues.length} (old/new/unload)",
    );
    await repo.addValues(unloadedValues);
    notifier.addValues(unloadedValues);
  }
  Future<void> load() async =>
    checkFirstLaunchAndLoad();


  Future<void> defaultLoad() async {
    final templates = await repo.fetchAllValues();

    if (templates.isEmpty) {
      templates.addAll(await jsonInteractor.loadFromJson());
    }
    await addValues(templates);
  }

  Future<void> checkFirstLaunchAndLoad() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('first_launch_done');
    final isFirstLaunch = prefs.getBool('first_launch_done') ?? false;
    logger.d('isFirstLaunch: $isFirstLaunch');

    final templates = await repo.fetchAllValues();

    if (!isFirstLaunch){
      final data = await jsonInteractor.loadFromFireStore();
      templates.addAll(data);
      await prefs.setBool('first_launch_done', true);
    }
    await addValues(templates);
  }

  Future<void> remove(String id) async {
    await repo.remove(id);
    final values = await repo.fetchAllValues();

    logger.d("templates ${values.length}");
    await notifier.remove(id);
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
