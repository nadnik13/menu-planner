import 'package:food_planner/core/extensions/date_extensions.dart';
import 'package:food_planner/providers/daily_plan/notifier.dart';
import '../../models/daily_plan/daily_plan.dart';

class DailyPlanInteractor {
  final DailyPlanNotifier _notifier;

  DailyPlanInteractor(this._notifier);

  Future<void> loadValues() async {
    _notifier.loadValues();
  }

  int getCntPlansOnFuture() => _notifier.cntPlansOnFuture();

  Future<void> add(DateTime date, Map<String, int> dishStockPortions) async {
    final plan = DailyPlan(date: date.dateOnly, portions: dishStockPortions);
    _notifier.addOrReplace(plan);
  }

  Future<void> removeByDate(DateTime date) async {
    _notifier.removeByKey(date);
  }

  Future<void> removeMealFromPlans(String mealId) async {
    _notifier.removeMealFromPlans(mealId);
  }

  DailyPlan getPlanByDate(DateTime date) =>
      _notifier.getByDate(date) ?? DailyPlan(date: date, portions: {});

  Future<void> save({
    required DateTime date,
    required Map<String, int> dishStockCntMap,
  }) async {
    final plan = DailyPlan(date: date, portions: dishStockCntMap);
    _notifier.addOrReplace(plan);
  }
}
