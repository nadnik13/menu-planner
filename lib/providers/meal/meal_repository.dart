import 'package:hive/hive.dart';
import '../../models/meal.dart';

class MealRepository {
  final Box<Meal> _box;

  MealRepository(this._box);

  Future<void> addOrReplaceMeal(Meal meal) async {
    await _box.put(meal.id, meal);
  }

  Future<Meal?> getMealByKey(String key) async => _box.get(key);

  Future<Set<Meal>> fetchAllMeals() async => _box.values.toSet();

  Future<void> removeMealByKey(String id) async {
    await _box.delete(id);
  }
}
