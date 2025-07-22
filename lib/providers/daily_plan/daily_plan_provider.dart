import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/daily_plan/daily_plan.dart';

class DailyPlanNotifier extends StateNotifier<List<DailyPlan>> {
  DailyPlanNotifier() : super(<DailyPlan>[]);

  List<DailyPlan> get fetchAllMealPlans => state;

  void loadValues(List<DailyPlan> plans) {
    state = plans;
  }

  void addOrReplace(DailyPlan plan) {
    state = state.where((e) => e.date != plan.date).toList();
    state = [...state, plan];
  }

  void removeByKey(DateTime date) {
    state = state.where((e) => e.date != date).toList();
  }

  DailyPlan? getByDate(DateTime date) =>
      state.where((e) => e.date == date).firstOrNull;

  int cntPlansOnFuture() =>
      state.where((e) => e.date.isAfter(DateTime.now())).length;
}

final dailyPlanProvider =
    StateNotifierProvider<DailyPlanNotifier, List<DailyPlan>>(
      (ref) => DailyPlanNotifier(),
    );

final daysPlanProvider = Provider<Map<DateTime, DailyPlan>>((ref) {
  final plans = ref.watch(dailyPlanProvider);
  return {for (var e in plans) e.date: e};
});

/// ✅ РЕАКТИВНЫЙ провайдер для статистики планов на будущее
/// Автоматически пересчитывается при изменении dailyPlanProvider
final futurePlansCountProvider = Provider<int>((ref) {
  final plans = ref.watch(dailyPlanProvider);
  return plans.where((e) => e.date.isAfter(DateTime.now())).length;
});
