import 'package:food_planner/core/logger.dart';
import 'package:food_planner/providers/dish_template/json_load_interactor.dart';
import 'package:food_planner/providers/dish_template/notifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/dish_template/dish_template.dart';

class DishTemplateInteractor {
  final DishTemplateNotifier notifier;
  final DishTemplateJsonLoadInteractor jsonInteractor;

  DishTemplateInteractor(this.notifier, this.jsonInteractor);

  Future<void> _add(DishTemplate template) async {
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
    notifier.addValues(newValues);
  }

  Future<void> load() async => checkFirstLaunchAndLoad();

  Future<void> checkFirstLaunchAndLoad() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('first_launch_done');
    final isFirstLaunch = prefs.getBool('first_launch_done') ?? false;
    logger.d('isFirstLaunch: $isFirstLaunch');

    final templates = notifier.fetchAllValues;

    if (!isFirstLaunch) {
      final data = await jsonInteractor.loadFromFireStore();
      templates.addAll(data);
      await prefs.setBool('first_launch_done', true);
    }
    await addValues(templates);
  }

  Future<void> remove(String id) async {
    await notifier.remove(id);
  }
}
