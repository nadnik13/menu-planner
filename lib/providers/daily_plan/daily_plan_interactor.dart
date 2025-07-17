import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:food_planner/core/extensions/date_extensions.dart';
import 'package:food_planner/providers/daily_plan/daily_plan_provider.dart';
import '../../models/daily_plan/daily_plan.dart';
import 'daily_plan_repository.dart';

class DailyPlanInteractor {
  final DailyPlanRepository _repository;
  final DailyPlanNotifier _notifier;

  DailyPlanInteractor(this._repository, this._notifier);

  Future<void> loadValues() async {
    final plans = await _repository.fetchAllValues();
    _notifier.loadValues(plans);
  }

  int getCntPlansOnFuture() => _notifier.cntPlansOnFuture();

  Future<void> add(DateTime date, Map<String, int> dishStockPortions) async {
    final plan = DailyPlan(date: date.dateOnly, portions: dishStockPortions);
    await _repository.addOrReplace(plan);
    _notifier.addOrReplace(plan);
  }

  Future<void> removeByDate(DateTime date) async {
    await _repository.removeByKey(date.dateKey);
    _notifier.removeByKey(date);
  }

  Future<void> removeMealFromPlans(String mealId) async {
    final plans = _notifier.fetchAllMealPlans;
    for (final plan in plans) {
      if (plan.portions.containsKey(mealId)) {
        plan.portions.remove(mealId);
        if (plan.portions.isEmpty) {
          await _repository.removeByKey(plan.date.dateKey);
        } else {
          await _repository.addOrReplace(plan);
        }
        _notifier.addOrReplace(plan);
      }
    }
  }

  DailyPlan getPlanByDate(DateTime date) =>
      _notifier.getByDate(date) ?? DailyPlan(date: date, portions: {});

  Future<void> save({
    required DateTime date,
    required Map<String, int> dishStockCntMap,
  }) async {
    final plan = DailyPlan(date: date, portions: dishStockCntMap);
    await _repository.addOrReplace(plan);
    _notifier.addOrReplace(plan);
  }
}

final dailyPlanRepositoryProvider = Provider((ref) {
  final box = Hive.box<DailyPlan>('DailyPlanBox');
  return DailyPlanRepository(box);
});

final dailyPlanInteractorProvider = Provider<DailyPlanInteractor>((ref) {
  final repo = ref.watch(dailyPlanRepositoryProvider);
  final notifier = ref.watch(dailyPlanProvider.notifier);
  return DailyPlanInteractor(repo, notifier);
});
