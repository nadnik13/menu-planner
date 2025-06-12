import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../../models/daily_plan.dart';
import '../../core/hive_box_names.dart';
import '../../core/extensions/date_extensions.dart';

class DailyPlanRepository {
  final Box<DailyPlan> _box;

  DailyPlanRepository(this._box);

  Future<List<DailyPlan>> loadPlans() async {
    return _box.values.toList();
  }

  Future<void> savePlan(DailyPlan plan) async {
    await _box.put(plan.date.dateKey, plan);
  }

  Future<void> deletePlan(DailyPlan plan) async {
    await _box.delete(plan.date.dateKey);
  }
}

final dailyPlanRepositoryProvider = Provider<DailyPlanRepository>((ref) {
  final box = Hive.box<DailyPlan>(HiveBoxNames.dailyPlan);
  return DailyPlanRepository(box);
}); 