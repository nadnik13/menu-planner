import 'package:hive/hive.dart';
import 'package:food_planner/core/extensions/date_extensions.dart';
import '../../models/daily_plan/daily_plan.dart';

class DailyPlanRepository {
  final Box<DailyPlan> _box;

  DailyPlanRepository(this._box);

  Future<void> addOrReplace(DailyPlan plan) async {
    final dateKey = plan.date.dateKey;
    await _box.put(dateKey, plan);
  }

  Future<List<DailyPlan>> fetchAllValues() async => _box.values.toList();

  Future<void> removeByKey(String key) async {
    if (_box.containsKey(key)) {
      await _box.delete(key);
    }
  }

  Future<DailyPlan?> getByKey(String key) async => _box.get(key);
}
